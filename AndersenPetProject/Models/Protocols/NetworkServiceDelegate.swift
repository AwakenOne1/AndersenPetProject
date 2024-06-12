//
//  NetworkServiceDelegate.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation

protocol NetworkServiceDelegate: AnyObject {
    func didFetchImages(_ images: [ImageInfo])
    func didFailWithError(error: Errors)
}
