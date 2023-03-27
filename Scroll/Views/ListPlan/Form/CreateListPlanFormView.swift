//
//  CreateListPlanFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/26/23.
//

import SwiftUI

struct CreateListPlanFormView: View {
  @Environment(\.managedObjectContext) private var viewContext

  var contents: [Content.ID] = []

  @State private var viewState: ViewState<EntryList, Error> = .idle

  var body: some View {
    StateView(state: $viewState) {
      let list = EntryList(context: viewContext)
      let contents = contents
        .compactMap { CoreDataStack.getObject(from: $0, with: viewContext) as? Content }
        .map { content in
          let entry = Entry(context: viewContext)
          entry.content = content

          return entry
        }

      list.addToEntries(Set(contents))

      viewState = .loaded(list)
    } loaded: { list in
      ListPlanFormView(purpose: .create, list: list)
    } failed: { _ in }
  }
}

struct CreateListPlanFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateListPlanFormView()
  }
}
