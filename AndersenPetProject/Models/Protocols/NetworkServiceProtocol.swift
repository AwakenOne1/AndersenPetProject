//
//  NetworkServiceProtocol.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    var currentPage: Int { get set }
    func fetchImageInfo()
    func searchImages(for searchText: String)
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void)
}
