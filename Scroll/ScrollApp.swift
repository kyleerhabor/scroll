//
//  ScrollApp.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI

@main
struct ScrollApp: App {
  let viewContext = CoreDataStack.shared.container.viewContext

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, viewContext)
    }

    WindowGroup("Create Title", id: "create-title-form") {
      CreateTitleFormView()
        .environment(\.managedObjectContext, viewContext)
    }

    // For views where the ID is nil (seems to be from restoration not being possible; don't know how), I'd like to show
    // a default search view (or maybe just a not found page, but that would be awkward).

    WindowGroup("Edit Title", id: "edit-title-form", for: Title.ID.self) { $id in
      if let id {
        EditTitleFormView(id: id)
          .environment(\.managedObjectContext, viewContext)
      }
    }.commandsRemoved()

    WindowGroup("Create Content", id: "create-content-form", for: Title.ID.self) { $id in
      if let id {
        CreateContentFormView(titleId: id)
          .environment(\.managedObjectContext, viewContext)
      }
    }.commandsRemoved()

    WindowGroup("Edit Content", id: "edit-content-form", for: Content.ID.self) { $id in
      if let id {
        EditContentFormView(id: id)
          .environment(\.managedObjectContext, viewContext)
      }
    }.commandsRemoved()

    WindowGroup("Create Entry", id: "create-entry-form", for: Content.ID.self) { $id in
      if let id {
        CreateEntryFormView(contentId: id)
          .environment(\.managedObjectContext, childContext(from: viewContext))
      }
    }.commandsRemoved()
  }

  func childContext(from context: NSManagedObjectContext) -> NSManagedObjectContext {
    let child = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    child.parent = viewContext

    return child
  }
}
