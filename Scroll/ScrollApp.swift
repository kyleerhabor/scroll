//
//  ScrollApp.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI

@main
struct ScrollApp: App {
  private let viewContext = getViewContext()
  private let createTitleViewContext = getViewContext().child()
  private let editTitleViewContext = getViewContext().child()
  private let createEntryViewContext = getViewContext().child()
  private let createListPlanViewContext = getViewContext().child()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, viewContext)
    }

    Settings {
      SettingsView()
    }

    // Note that every Entity.ID is a URL, so the preceding identifier actually needs to be unique for each type.

    WindowGroup("Create Title", id: "create-title-form") {
      CreateTitleFormView()
        // I need to create some kind of store to hold these.
        .environment(\.managedObjectContext, createTitleViewContext)
        .onDisappear(perform: saveChanges)
    }

    // For views where the ID is nil (seems to be from restoration not being possible; don't know how), I'd like to show
    // a default search view (or maybe just a not found page, but that would be awkward).

    WindowGroup("Edit Title", id: "edit-title-form", for: Title.ID.self) { $id in
      if let id {
        EditTitleFormView(id: id)
          .environment(\.managedObjectContext, editTitleViewContext)
          .onDisappear(perform: saveChanges)
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
          .onDisappear(perform: saveChanges)
      }
    }.commandsRemoved()

    WindowGroup("Create List Plan", id: "list-plan.create", for: [Content.ID].self) { $ids in
      Group {
        if let ids {
          CreateListPlanFormView(contents: ids)
        } else {
          CreateListPlanFormView()
        }
      }
      .environment(\.managedObjectContext, createListPlanViewContext)
      .onDisappear(perform: saveChanges)
    }
  }

  static func getViewContext() -> NSManagedObjectContext {
    CoreDataStack.shared.container.viewContext
  }

  func saveChanges() {
    if viewContext.hasChanges {
      _ = try? viewContext.save() as Void
    }
  }
}
