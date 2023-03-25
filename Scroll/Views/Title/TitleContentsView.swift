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
  @State private var didError = false

  var body: some View {
    // Some contents (such as light novel chapters) have cover art which could look better than a vertical list of text.
    // However, a lot of contents don't, such as TV episodes where they instead opt to use a frame as the cover, which
    // is often awkward. I think providing an option for the user to set whether or not the list should use cover images
    // would be an interesting solution. The only problem, then, is whether or not it should apply to all contents, a
    // subset (e.g. in a certain group), a rule, etc.
    //
    // Another approach may be to check the list and see if any of them have covers, and, if so, just display them all
    // as covers instead.
    List {
      ForEach(contents) { content in
        NavigationLink(value: Navigation.content(content)) {
          Text(content.title!)
        }
      }.onDelete { indicies in
        let staged = indicies.map { contents[$0] } // I don't see why I can't just use contents.subscript

        if !staged.isEmpty {
          staged.forEach(viewContext.delete)

          if case .failure = viewContext.save() {
            didError = true
          }
        }
      }
    // Since there could have been many contents the user tried to delete in one, the error message could be improved.
    }.alert("Could not delete content.", isPresented: $didError) {} //
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
