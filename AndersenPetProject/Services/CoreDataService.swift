//
//  CoreDataService.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 11.06.24.
//

import Foundation
import CoreData
import UIKit

final class CoreDataService: CoreDataServiceProtocol {

    private weak var delegate: CoreDataServiceDelegate?

    init(delegate: CoreDataServiceDelegate?) {
        self.delegate = delegate
    }

    private func createContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("сast failed") }
        return appDelegate.persistentContainer.viewContext
    }

    func checkIfSaved(id: String) -> Bool {
        let context = createContext()
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(fetchRequest)
            if result.first != nil {
                return true
            } else {
                return false
            }
        } catch {
            delegate?.didFailWithError(error: Errors.fetchingError)
            return false
        }
    }

    func saveImageToFavourites(imageInfo: ImageInfo) {
        let context = createContext()
        _ = imageInfo.toImageEntity(in: context)
        do {
            try context.save()
        } catch {
            delegate?.didFailWithError(error: Errors.savingError)
        }
    }

    func fetchSavedPhotos() {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            let context = createContext()
            let items = try context.fetch(fetchRequest)
            delegate?.didFetchSavedPhotos(images: items.map { $0.toImageInfo() })
        } catch {
            delegate?.didFailWithError(error: Errors.fetchingError)
        }
    }

    func deleteImageFromFavourite(imageInfo: ImageInfo) {
        let context = createContext()
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", imageInfo.id)
        fetchRequest.predicate = predicate
        do {
            let entitiesToDelete = try context.fetch(fetchRequest)
            for entity in entitiesToDelete {
                context.delete(entity)
            }
            try context.save()
            delegate?.didChangeFavoriteStatus()
        } catch {
            delegate?.didFailWithError(error: Errors.deletingError)
        }
    }
}
