//
//  ImageInfo.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import CoreData

struct ImageInfo: Decodable {
    let id: String
    let slug: String
    let altDescription: String?
    let urls: Urls
    var isFavourite = false

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case altDescription = "alt_description"
        case urls
    }

    init(id: String, slug: String, altDescription: String?, urls: Urls, isFavourite: Bool = false) {
        self.id = id
        self.slug = slug
        self.altDescription = altDescription
        self.urls = urls
        self.isFavourite = isFavourite
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.altDescription = try container.decodeIfPresent(String.self, forKey: .altDescription)
        self.urls = try container.decode(Urls.self, forKey: .urls)
    }

}

struct Urls: Codable {
    let small: String
    let regular: String
    var smallURL: URL {
        return URL(string: small)!
    }
    var regularURL: URL {
        return URL(string: regular)!
    }
}

extension ImageInfo {
    func toImageEntity(in context: NSManagedObjectContext) -> ImageEntity {
        let entity = ImageEntity(context: context)
        entity.id = id
        entity.slug = slug
        entity.altDescription = altDescription
        entity.smallURL = urls.small
        entity.regularUrl = urls.regular
        entity.isFavourite = isFavourite
        return entity
    }
}
