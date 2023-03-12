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
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }

    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
