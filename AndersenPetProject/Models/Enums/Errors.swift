//
//  Errors.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation

import Foundation

enum Errors: LocalizedError {
    case decodingError
    case savingError
    case fetchingError
    case deletingError

    var description: String {
        switch self {
        case .decodingError: return "Decoding Error"
        case .savingError: return "Failed to save image"
        case .fetchingError: return "Failed to fetch images"
        case .deletingError: return "Failed to delete image"
        }
    }
}
