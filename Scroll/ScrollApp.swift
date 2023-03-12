//
//  ScrollApp.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI

@main
struct ScrollApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    let viewContext = persistenceController.container.viewContext

    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, viewContext)
    }

    WindowGroup(id: "title-form", for: Title.ID.self) { id in // Why is id a binding?
      TitleFormView(id: id)
        .environment(\.managedObjectContext, viewContext)
    }
  }
}
