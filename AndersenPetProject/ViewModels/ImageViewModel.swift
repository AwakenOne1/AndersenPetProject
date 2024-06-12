//
//  ImageViewModel.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

final class ImageViewModel: NetworkServiceDelegate, CoreDataServiceDelegate, ImageViewModelProtocol {
    
    var imagesInfo: [ImageInfo] = [] {
        didSet {
            delegate?.reload()
        }
    }
    
    weak var delegate: ImageViewModelDelegate?
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService(delegate: self)
    private lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(delegate: self)
    
    // MARK: - NetworkService
    func increasePageNumber() {
        networkService.currentPage += 1
    }
    
    func searchImages(for searchText: String) {
        networkService.searchImages(for: searchText)
    }
    
    func fetchImageInfo() {
        networkService.fetchImageInfo()
    }
    
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void) {
        networkService.fetchImageForInfo(url: url, completion: completion)
    }
    
    // MARK: - CoreDataService
    func checkIfSaved(id: String) -> Bool {
        return coreDataService.checkIfSaved(id: id)
    }
    
    func deleteImageFromFavourite(imageInfo: ImageInfo) {
        coreDataService.deleteImageFromFavourite(imageInfo: imageInfo)
    }
    
    func saveImageToFavourites(imageInfo: ImageInfo) {
        coreDataService.saveImageToFavourites(imageInfo: imageInfo)
    }
    
    // MARK: - Delegate Methods
    func fetchSavedPhotos() {
        coreDataService.fetchSavedPhotos()
    }
    
    func didFetchImages(_ images: [ImageInfo]) {
        imagesInfo.append(contentsOf: images)
    }
    
    func didFailWithError(error: Errors) {
        delegate?.showError(description: error.description)
    }
    
    func didChangeFavoriteStatus() {
        delegate?.reload()
    }
    
    func didFetchSavedPhotos(images: [ImageInfo]) {
        self.imagesInfo = images
        delegate?.reload()
    }
    func resetPages() {
        networkService.resetPages()
    }
}
