//
//  EditTitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/13/23.
//

import SwiftUI

struct EditTitleFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var id: Title.ID
  @State private var title = ""
  @State private var cover: Data?
  @State private var description = ""
  @State private var didError = false

  var body: some View {
    TitleFormView(
      purpose: .edit,
      title: $title,
      cover: $cover,
      description: $description,
      submit: submit,
      cancel: dismiss.callAsFunction
    ).onAppear {
      let ttl = getTitle()
      title = ttl.title!
      cover = ttl.cover

      if let desc = ttl.desc {
        description = desc
      }
    }.alert("Could not create title.", isPresented: $didError) {}
  }

  func getTitle() -> Title {
    CoreDataStack.getObject(from: id, with: viewContext) as! Title
  }

  func submit() {
    let title = getTitle()
    title.title = self.title

    if !description.isEmpty {
      title.desc = description
    }

    title.cover = cover

    guard case .success = viewContext.save() else {
      didError = true

      return
    }

    dismiss()
  }
}

struct EditTitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    EditTitleFormView(id: .nullDevice)
  }
}
