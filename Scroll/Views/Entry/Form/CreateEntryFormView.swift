//
//  CreateEntryFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/17/23.
//

import SwiftUI

struct CreateEntryFormView: View {
  @Environment(\.managedObjectContext) private var viewContext

  var contentId: Content.ID

  var body: some View {
    DataView { (entry: Entry) in
      EntryFormView(purpose: .create, entry: entry)
    } hidden: {
      HiddenView()
    } loading: {
      if let content = CoreDataStack.getObject(from: contentId, with: viewContext) as? Content {
        let entry = Entry(context: viewContext)
        entry.content = content

        return entry
      }

      return nil
    }
  }
}

struct CreateEntryFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateEntryFormView(contentId: .nullDevice)
  }
}
