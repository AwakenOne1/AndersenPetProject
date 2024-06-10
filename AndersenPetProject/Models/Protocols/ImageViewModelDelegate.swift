//
//  ImageViewModelDelegate.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation

protocol ImageViewModelDelegate: AnyObject {
    func reload()
    func showError(description: String)
}
