//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.openWindow) private var openWindow

  // New titles should appear first.
  @FetchRequest(sortDescriptors: [.init(keyPath: \NSManagedObject.objectID, ascending: false)])
  private var titles: FetchedResults<Title>

  var body: some View {
    NavigationStack {
      ScrollView {
        let width: CGFloat = 128

        LazyVGrid(columns: [.init(.adaptive(minimum: width))]) {
          ForEach(titles) { title in
            NavigationLink(value: title) {
              // For some reason, the blue outline (highlight) is taller than the actual view.
              //
              // The default spacing is a bit much; 4 is too much, and 2 is a bit too short. 3 looks "fine".
              VStack(alignment: .leading, spacing: 3) {
                TitleCoverView(cover: title.cover)
                  .frame(width: width, height: titleCoverHeight(from: width))
                  .titleCoverStyle()

                let name = title.title!

                // The line limit with reserved spacing is enforced to align the titles (specifically the cover images)
                // horizontally. A limit of 1 is compact and too short for many titles; a limit of 3 is too spacious and
                // still suseptible to longer titles; a limit of 2 catches many titles while missing some (e.g. "Made in
                // Abyss: The Golden City of the Scorching Sun"), but is "just right".
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
              Button {
                openWindow(id: "title-form", value: title.id)
              } label: {
                Label("Edit", systemImage: "pencil")
              }
            }
          }
        }.padding()
      }
      .navigationTitle("Titles")
      .navigationDestination(for: Title.self) { title in
        TitleView(title: title)
      }.toolbar {
        // In the future, I'd like to provide users the ability to create or *import* titles (likely in some file format).
        // When that happens, this will likely be a Menu.
        Button {
          openWindow(id: "title-form")
        } label: {
          Label("Create", systemImage: "plus")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
