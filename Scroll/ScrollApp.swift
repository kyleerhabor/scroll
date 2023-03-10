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
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }

    // Maybe accept a title object? Would allow it to be pre-filled
    WindowGroup(id: "new-title") {
      TitleFormView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
