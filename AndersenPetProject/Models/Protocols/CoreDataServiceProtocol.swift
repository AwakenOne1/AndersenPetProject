//
//  CoreDataServiceProtocol.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//

import Foundation

protocol CoreDataServiceProtocol {
    func checkIfSaved(id: String) -> Bool
    func saveImageToFavourites(imageInfo: ImageInfo)
    func fetchSavedPhotos()
    func deleteImageFromFavourite(imageInfo: ImageInfo)
}
