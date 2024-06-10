//
//  ImageViewModel.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

final class ImageViewModel: ImageViewModelProtocol {
    
    var imagesInfo: [ImageInfo] = [] {
            didSet {
                delegate?.reload()
            }
        }
    
    weak var delegate: ImageViewModelDelegate?
    
    func fetchImageInfo() {
        <#code#>
    }
    
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void) {
        <#code#>
    }
}
