//
//  CreateContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct CreateContentFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var titleId: Title.ID
  @State private var name = ""
  @State private var didError = false

  var body: some View {
    ContentFormView(
      purpose: .create,
      title: $name,
      submit: submit,
      cancel: dismiss.callAsFunction
    ).alert("Could not create content", isPresented: $didError) {}
  }

  func submit() {
    let content = Content(context: viewContext)
    content.title = name
    content.titleRef = (PersistenceController.getObject(from: titleId, with: viewContext) as! Title)

    do {
      try viewContext.save()

      dismiss()
    } catch let err {
      print(err)

      didError = true
    }
  }
}

struct CreateContentFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateContentFormView(titleId: .nullDevice)
  }
}
