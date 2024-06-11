//
//  CoreDataServiceDelegate.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//

import Foundation

protocol CoreDataServiceDelegate: AnyObject {
    func didChangeFavoriteStatus()
    func didFetchSavedPhotos(images: [ImageInfo])
    func didFailWithError(error: Error)
}
