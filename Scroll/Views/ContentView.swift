//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  // For some reason, creating a title appends to the list when using .objectID as the keypath. Refreshing fixes the
  // order, so I have a slight feeling it's caused by temporary IDs.
  @FetchRequest(sortDescriptors: [.init(\.title)],
                animation: .default)
  private var titles: FetchedResults<Title>

  var body: some View {
    NavigationStack {
      // Maybe a generic list should be used? But that may look worse... Maybe just on screens that are smaller? (iOS)
      ScrollView {
        let width: CGFloat = 128

        LazyVGrid(columns: [.init(.adaptive(minimum: width))]) {
          ForEach(titles) { title in
            NavigationLink(value: title) {
              // For some reason, the blue outline (highlight) is sometimes wider than the view by a variable amount.
              //
              // The default spacing is a bit much; 4 is too much, and 2 is a bit too short. 3 looks "fine".
              VStack(alignment: .leading, spacing: 3) {
                TitleCoverView(cover: title.cover)
                  .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                  .titleCoverStyle()

                let name = title.title!

                // The line limit with reserved spacing is enforced to align the titles (specifically the cover images)
                // vertically. A limit of 1 is compact and too short for many titles; a limit of 3 is too spacious and
                // still suseptible to longer titles; a limit of 2 catches many titles while missing some (e.g. "Made in
                // Abyss: The Golden City of the Scorching Sun"), but is "just right" for how much space it occupies.
                Text(name)
                  .font(.callout)
                  .bold()
                  .lineLimit(2, reservesSpace: true)
                  .help(name)
              }
            }
            .frame(width: width)
            .buttonStyle(.plain)
            .contextMenu {
              EditTitleButtonView(id: title.id)
            }
          }
        }.padding()
      }
      .navigationTitle("Titles")
      .navigationDestination(for: Title.self) { title in
        TitleView(title: title)
      }.navigationDestination(for: Content.self) { content in
        TContentView(content: content)
      }.navigationDestination(for: Navigation.self) { location in
        switch location {
          case .contents(let title):
            TitleContentsView(title: title)
        }
      }.toolbar {
        // In the future, I'd like to provide users the ability to create or *import* titles (likely in some file format).
        // When that happens, this will likely be a Menu.
        CreateTitleButtonView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
