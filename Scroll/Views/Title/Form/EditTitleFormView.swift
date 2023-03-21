//
//  EditTitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/20/23.
//

import SwiftUI

struct EditTitleFormView: View {
  @Environment(\.managedObjectContext) private var viewContext

  var id: Title.ID

  var body: some View {
    DataView { (title: Title) in
      TitleFormView(title: title, purpose: .edit)
    } hidden: {
      HiddenView()
    } loading: {
      return CoreDataStack.getObject(from: id, with: viewContext) as? Title
    }
  }
}

struct EditTitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    EditTitleFormView(id: .nullDevice)
  }
}
