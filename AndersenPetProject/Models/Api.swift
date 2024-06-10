//
//  Api.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation

struct Api {
    static let apiKey = "No87779kd3Q2rPOrUFije8BkFuXmkbYnpRxCpA4tGFw"
    static let scheme = "https"
    static let host = "api.unsplash.com"
    static let path = "/photos/"
    static let itemsPerPage = "30"
    static let queryItems = ["page", "per_page", "client_id"]
}
