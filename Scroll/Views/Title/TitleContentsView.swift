//
//  TitleContentsView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/19/23.
//

import SwiftUI

struct TitleContentsView: View {
  @Environment(\.managedObjectContext) private var viewContext

  let title: Title

  @FetchRequest private var contents: FetchedResults<Content>
  @State private var didErrorOnDelete = false

  var body: some View {
    List {
      ForEach(contents) { content in
        NavigationLink(value: content) {
          Text(content.title!)
        }
      }.onDelete { indicies in
        let staged = indicies.map { contents[$0] } // I don't see why I can't just use contents.subscript

        if !staged.isEmpty {
          staged.forEach(viewContext.delete)

          do {
            try viewContext.save()
          } catch let err {
            print(err)

            didErrorOnDelete = true
          }
        }
      }
    }
    .navigationTitle("Contents")
    .navigationSubtitle(title.title!)
    // Since there could have been many contents the user tried to delete in one, the error message could be improved.
    .alert("Could not delete content.", isPresented: $didErrorOnDelete) {}
  }

  init(title: Title) {
    self.title = title
    self._contents = .init(
      sortDescriptors: [],
      predicate: .init(format: "titleRef = %@", title),
      animation: .default
    )
  }
}

struct TitleContentsView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let title: Title = {
    let title = Title(context: context)
    title.title = "Crest of the Stars" // The novel

    var content = Content(context: context)
    content.title = "Delktu Spaceport"
    content.titleRef = title

    content = Content(context: context)
    content.title = "Apprentice Starpilot"
    content.titleRef = title

    return title
  }()

  static var previews: some View {
    NavigationStack {
      TitleContentsView(title: title)
    }
  }
}
