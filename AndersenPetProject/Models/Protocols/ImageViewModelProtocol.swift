//
//  ImageViewModelProtocol.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

protocol ImageViewModelProtocol: AnyObject {
    
    var imagesInfo: [ImageInfo] { get set}
    
    func fetchImageInfo()
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void)
    
}
