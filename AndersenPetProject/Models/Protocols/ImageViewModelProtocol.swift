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
    var delegate: ImageViewModelDelegate? { get set}
    
    func checkIfSaved(id: String) -> Bool
    func increasePageNumber()
    func fetchSavedPhotos()
    func fetchImageInfo()
    func searchImages(for searchText: String)
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void)
    func resetPages()
    func deleteImageFromFavourite(imageInfo: ImageInfo)
    func saveImageToFavourites(imageInfo: ImageInfo)
}
