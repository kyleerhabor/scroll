//
//  CreateContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct CreateContentFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  private(set) var titleId: Title.ID
  private var title: Title {
    let id = viewContext.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: titleId)!

    return try! (viewContext.existingObject(with: id) as! Title)
  }

  @State private var name = ""

  @State private var didFailToCreate = false

  var body: some View {
    ContentFormView(purpose: .create, title: $name) {
      let content = Content(context: viewContext)
      content.title = name
      content.titleRef = title

      do {
        try viewContext.save()

        dismiss()
      } catch let err {
        print(err)

        didFailToCreate = true
      }
    } cancel: {
      dismiss()
    }.alert("Failed to create content", isPresented: $didFailToCreate) {}
  }
}

struct CreateContentFormView_Previews: PreviewProvider {
  static private let viewContext = PersistenceController.preview.container.viewContext

  static var previews: some View {
    CreateContentFormView(titleId: .init(string: "/dev/null")!)
      .environment(\.managedObjectContext, viewContext)
  }
}
