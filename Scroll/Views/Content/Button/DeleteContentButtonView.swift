//
//  DeleteContentButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct DeleteContentButtonView: View {
  @Environment(\.managedObjectContext) private var viewContext
  private(set) var content: Content

  @State private var confirming = false
  @State private var didError = false

  var body: some View {
    Button(role: .destructive) {
      confirming = true
    } label: {
      Label("Delete Content", systemImage: "minus")
    }.confirmationDialog("Are you sure you would like to delete this content?", isPresented: $confirming) {
      Button("Delete", role: .destructive) {
        viewContext.delete(content)

        if case .failure = viewContext.save() {
          didError = true
        }
      }
    }
  }
}

struct DeleteContentButtonView_Previews: PreviewProvider {
  static private let viewContext = CoreDataStack.preview.container.viewContext
  static private let content: Content = {
    let content = Content(context: viewContext)
    content.title = "Kin of the Stars"
    // Add some more stuff later.

    return content
  }()

  static var previews: some View {
    DeleteContentButtonView(content: content)
  }
}
