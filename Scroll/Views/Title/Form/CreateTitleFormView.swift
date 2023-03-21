//
//  CreateTitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/20/23.
//

import SwiftUI

struct CreateTitleFormView: View {
  @Environment(\.managedObjectContext) private var viewContext

  var body: some View {
    DataView { (title: Title) in
      TitleFormView(title: title, purpose: .create)
    } hidden: {
      HiddenView()
    } loading: {
      // Maybe I can create the context here? It didn't work last time though.
      let title = Title(context: viewContext)

      return title
    }
  }
}

struct CreateTitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateTitleFormView()
  }
}
