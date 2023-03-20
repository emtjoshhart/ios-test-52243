//
//  DataController.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import CoreData

class DataController: NSObject {
    let persistentContainer: NSPersistentContainer

    lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            completion?()
        }
    }

    func clearDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }

        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }
}
