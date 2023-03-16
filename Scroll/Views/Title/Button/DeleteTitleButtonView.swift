//
//  DeleteTitleButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct DeleteTitleButtonView: View {
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var title: Title

  @State private var isPresentingDeleteDialog: Bool = false
  @State private var didFailToDelete: Bool = false

  var body: some View {
    Button(role: .destructive) {
      isPresentingDeleteDialog = true
    } label: {
      Label("Delete Title", systemImage: "minus")
    // NOTE: This does not work in LazyVGrid for some reason.
    }.confirmationDialog("Are you sure you would like to delete this title?", isPresented: $isPresentingDeleteDialog) {
      Button("Delete", role: .destructive) {
        viewContext.delete(title)

        do {
          try viewContext.save()
        } catch let err {
          print(err)

          didFailToDelete = true
        }
      }
    }.alert("Failed to delete title", isPresented: $didFailToDelete) {}
  }
}

struct DeleteTitleButtonView_Previews: PreviewProvider {
  static private let viewContext = CoreDataStack.preview.container.viewContext

  static var previews: some View {
    DeleteTitleButtonView(title: .init(context: viewContext))
      .environment(\.managedObjectContext, viewContext)
  }
}
