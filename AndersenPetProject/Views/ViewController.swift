//
//  ViewController.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageViewModelDelegate, DetailDelegate, UISearchBarDelegate {
    private lazy var viewModel: ImageViewModelProtocol = ImageViewModel()

    private var isPaging = true
    private let searchBar = UISearchBar()
    private let segmentedControl = UISegmentedControl(items: ["All photos", "Favourites", "Search"])
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        addSubviews()
        setupConstraints()
        viewModel.delegate = self
        viewModel.fetchImageInfo()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .automatic
        searchBar.delegate = self
        searchBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: - FlowLayoutDelegate Methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 16
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (width - totalSpacing) / numberOfItemsPerRow
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }

    // MARK: - DataSource Methods

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else { fatalError("cast error")}
        let item = viewModel.imagesInfo[indexPath.row]
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.fetchImageForInfo(url: item.urls.smallURL) { image in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
        cell.favouriteImage.isHidden = !viewModel.checkIfSaved(id: item.id)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imagesInfo.count - 1 && segmentedControl.selectedSegmentIndex != 1 && isPaging {
            viewModel.increasePageNumber()
            viewModel.fetchImageInfo()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController(initialIndex: indexPath.row, viewModel: self.viewModel, delegate: self)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: - scrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    // MARK: - ImageViewModelDelegate
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func showError(description: String) {
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }

    // MARK: - DetailDelegate
    func updateIndicators() {
        collectionView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            guard let searchText = searchBar.text, !searchText.isEmpty else {
                return
            }
        viewModel.searchImages(for: searchText)
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               viewModel.imagesInfo = []
           }
       }

    // MARK: - Own Methods

    
    @objc private func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    private func configureSubviews() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
    }

    private func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        
    }
    
    private func reconfigureConstraints() {
        searchBar.snp.remakeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func showSearchBar() {
        searchBar.isHidden = false
        searchBar.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.searchBar.alpha = 1
        }
    }

    private func hideSearchBar() {
        searchBar.isHidden = true
    }

    @objc private func changeSegment() {
        dismissKeyboard()
        viewModel.resetPages()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            isPaging = true
            setupConstraints()
            viewModel.imagesInfo = []
            viewModel.fetchImageInfo()
            hideSearchBar()
        case 1:
            viewModel.imagesInfo = []
            setupConstraints()
            isPaging = false
            viewModel.fetchSavedPhotos()
            hideSearchBar()
        case 2:
            reconfigureConstraints()
            isPaging = false
            viewModel.imagesInfo = []
            showSearchBar()
        default:
            viewModel.fetchImageInfo()
            hideSearchBar()
        }
    }

}
