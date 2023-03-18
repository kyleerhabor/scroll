//
//  CreateTitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/13/23.
//

import SwiftUI

struct CreateTitleFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  @State private var title = ""
  @State private var cover: Data?
  @State private var description = ""
  @State private var didError = false

  var body: some View {
    TitleFormView(
      purpose: .create,
      title: $title,
      cover: $cover,
      description: $description,
      submit: submit
    ) {
      viewContext.rollback()
      dismiss()
    }.alert("Could not create title.", isPresented: $didError) {}
  }

  func submit() {
    let ttl = Title(context: viewContext)
    ttl.title = title

    if !description.isEmpty {
      ttl.desc = description
    }

    ttl.cover = cover

    do {
      try viewContext.save()

      dismiss()
    } catch let err {
      print(err)

      didError = true
    }
  }
}

struct CreateTitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateTitleFormView()
  }
}
