//
//  ImageEntity+CoreDataProperties.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var slug: String?
    @NSManaged public var altDescription: String?
    @NSManaged public var smallURL: String?
    @NSManaged public var regularUrl: String?
    @NSManaged public var isFavourite: Bool

}

extension ImageEntity : Identifiable {

}

extension ImageEntity {
    func toImageInfo() -> ImageInfo {
        if let smallURL = smallURL,
           let regularUrl = regularUrl,
           let id = id,
           let slug = slug {
            let urls = Urls(small: smallURL, regular: regularUrl)
            return ImageInfo(id: id, slug: slug, altDescription: altDescription ?? "", urls: urls, isFavourite: isFavourite)
        } else {
            fatalError("Corrupted data")
        }
    }
}
