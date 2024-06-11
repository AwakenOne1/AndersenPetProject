//
//  ViewController.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageViewModelDelegate, DetailDelegate {
    private lazy var viewModel: ImageViewModelProtocol = ImageViewModel()

    private let segmentedControl = UISegmentedControl(items: ["All photos", "Favourites"])
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

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
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: - FlowLayoutDelegate Methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
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
        if indexPath.row == viewModel.imagesInfo.count - 1 && segmentedControl.selectedSegmentIndex != 1 {
            viewModel.increasePageNumber()
            viewModel.fetchImageInfo()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController(initialIndex: indexPath.row, viewModel: self.viewModel, delegate: self)
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    // MARK: - ImageViewModelDelegate
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func showError(description: String) {
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }

    // MARK: - DetailDelegate
    func updateIndicators() {
        collectionView.reloadData()
    }

    // MARK: - Own Methods

    func configureSubviews() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
    }

    func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        segmentedControl.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }

        collectionView.snp.makeConstraints { [ unowned self] make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    @objc func changeSegment() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.imagesInfo = []
            viewModel.fetchImageInfo()
        case 1:
            viewModel.fetchSavedPhotos()
        default:
            viewModel.fetchImageInfo()
        }
    }

}
