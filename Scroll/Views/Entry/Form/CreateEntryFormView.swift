//
//  CreateEntryFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct CreateEntryFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var titleId: Title.ID
  @State private var title: Title?
  @State private var name = ""
  @State private var notes = ""

  var body: some View {
    EntryFormView(purpose: .create, title: title, name: $name, notes: $notes) {
      print("!!!")
    } cancel: {
      dismiss()
    }.onAppear {
      self.title = CoreDataStack.getObject(from: titleId, with: viewContext) as? Title
    }
  }
}

struct CreateEntryFormView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let titleId: Title.ID = {
    let title = Title(context: context)
    title.title = "Kin of the Stars"

    return title.id
  }()

  static var previews: some View {
    CreateEntryFormView(titleId: titleId)
  }
}
