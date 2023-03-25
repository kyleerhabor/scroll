//
//  ScrollApp.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI

@main
struct ScrollApp: App {
  private let viewContext = CoreDataStack.shared.container.viewContext
  private let createTitleViewContext = CoreDataStack.shared.container.viewContext.child()
  private let editTitleViewContext = CoreDataStack.shared.container.viewContext.child()
  private let createEntryViewContext = CoreDataStack.shared.container.viewContext.child()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, viewContext)
    }

    // Note that every Entity.ID is a URL, so the preceding identifier actually needs to be unique for each type.

    WindowGroup("Create Title", id: "create-title-form") {
      CreateTitleFormView()
        // I need to create some kind of store to hold these.
        .environment(\.managedObjectContext, createTitleViewContext)
        .onDisappear { saveChanges() }
    }

    // For views where the ID is nil (seems to be from restoration not being possible; don't know how), I'd like to show
    // a default search view (or maybe just a not found page, but that would be awkward).

    WindowGroup("Edit Title", id: "edit-title-form", for: Title.ID.self) { $id in
      if let id {
        EditTitleFormView(id: id)
          .environment(\.managedObjectContext, editTitleViewContext)
          .onDisappear { saveChanges() }
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
          .environment(\.managedObjectContext, createEntryViewContext)
          .onDisappear { saveChanges() }
      }
    }.commandsRemoved()

    Settings {
      SettingsView()
    }
  }

  func saveChanges() {
    if viewContext.hasChanges {
      _ = try? viewContext.save() as Void
    }
  }
}
