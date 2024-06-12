//
//  SearchResults.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 12.06.24.
//

import Foundation

struct SearchResults: Decodable {
    let results: [ImageInfo]
    
    enum CodingKeys: CodingKey {
        case results
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([ImageInfo].self, forKey: .results)
        print(self.results)
    }
}
