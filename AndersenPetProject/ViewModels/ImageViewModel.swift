//
//  ImageViewModel.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

final class ImageViewModel: ImageViewModelProtocol, NetworkServiceDelegate {
    
    var imagesInfo: [ImageInfo] = [] {
        didSet {
            delegate?.reload()
        }
    }
    
    weak var delegate: ImageViewModelDelegate?
    private lazy var networkService: NetworkServiceProtocol = NetworkService(delegate: self)
    
    
    func increasePageNumber() {
           networkService.currentPage += 1
    }
    
    func fetchImageInfo() {
        networkService.fetchImageInfo()
    }
    
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void) {
        networkService.fetchImageForInfo(url: url, completion: completion)
    }
    
    func didFetchImages(_ images: [ImageInfo]) {
        imagesInfo.append(contentsOf: images)
    }
    
    func didFailWithError(error: any Error) {
        delegate?.showError(description: error.localizedDescription)
    }
}
