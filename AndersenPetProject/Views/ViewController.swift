//
//  ViewController.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageViewModelDelegate {
    
    private lazy var viewModel: ImageViewModelProtocol = ImageViewModel()
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
    }
    // MARK: - FlowLayoutDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3+60, height: 200)
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imagesInfo.count - 1 {
            viewModel.increasePageNumber()
            viewModel.fetchImageInfo()
        }
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
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { [ unowned self] make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

