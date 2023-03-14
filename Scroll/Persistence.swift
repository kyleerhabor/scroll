//
//  Persistence.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  static let preview = PersistenceController(inMemory: true)

  let container: NSPersistentCloudKitContainer

  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Scroll")

    if inMemory {
      container.persistentStoreDescriptions.first!.url = .nullDevice
    }

    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
  }

  static func getId(from url: URL, with context: NSManagedObjectContext) -> NSManagedObjectID? {
    context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
  }

  static func getObject(from id: NSManagedObjectID, with context: NSManagedObjectContext) -> NSManagedObject? {
    try? context.existingObject(with: id)
  }

  static func getObject(from url: URL, with context: NSManagedObjectContext) -> NSManagedObject? {
    guard let id = self.getId(from: url, with: context) else {
      return nil
    }

    return self.getObject(from: id, with: context)
  }
}
