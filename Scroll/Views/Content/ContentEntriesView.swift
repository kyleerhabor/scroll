//
//  ContentEntriesView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/25/23.
//

import SwiftUI

struct ContentEntriesView: View {
  @ObservedObject var content: Content

  @FetchRequest private var entries: FetchedResults<Entry>

  var body: some View {
    List {
      ForEach(entries) { entry in
        NavigationLink("...", value: Navigation.entry(entry))
      }
    }
  }

  init(content: Content) {
    self.content = content
    _entries = .init(
      sortDescriptors: [],
      predicate: .init(format: "content = %@", content),
      animation: .default
    )
  }
}

struct ContentEntriesView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let content: Content = {
    let content = Content(context: context)

    return content
  }()

  static var previews: some View {
    ContentEntriesView(content: content)
  }
}
