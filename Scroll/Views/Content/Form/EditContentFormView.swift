//
//  EditContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct EditContentFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var id: Content.ID
  @State private var title = ""
  @State private var didError = false

  var body: some View {
    ContentFormView(
      purpose: .edit,
      title: $title,
      submit: submit,
      cancel: dismiss.callAsFunction
    )
    .alert("Could not edit content", isPresented: $didError) {}
    .onAppear {
      let content = getContent()
      title = content.title!
    }
  }

  func getContent() -> Content {
    PersistenceController.getObject(from: id, with: viewContext) as! Content
  }

  func submit() {
    let content = getContent()
    content.title = title

    do {
      try viewContext.save()

      dismiss()
    } catch let err {
      print(err)

      didError = true
    }
  }
}

struct EditContentFormView_Previews: PreviewProvider {
  static var previews: some View {
    EditContentFormView(id: .nullDevice)
  }
}
