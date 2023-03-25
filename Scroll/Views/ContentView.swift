//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @FetchRequest(
    sortDescriptors: [.init(\.title), .init(\.qualifier)],
    animation: .default
  )
  private var titles: FetchedResults<Title>

  @State private var navigator: [Navigation] = []
  // On macOS, this seems to not have an effect. Maybe on iOS?
  @SceneStorage("navigation") private var navigation: Data?

  var body: some View {
    NavigationStack(path: $navigator) {
      // Maybe a generic list should be used? But that may look worse... Maybe just on screens that are smaller? (iOS)
      ScrollView {
        let width: CGFloat = 128

        LazyVGrid(columns: [.init(.adaptive(minimum: width))]) {
          ForEach(titles) { title in
            NavigationLink(value: Navigation.title(title)) {
              // For some reason, the blue outline (highlight) is sometimes wider than the view by a variable amount.
              //
              // The default spacing is a bit much; 4 is too much, and 2 is a bit too short. 3 looks "fine".
              VStack(alignment: .leading, spacing: 3) {
                TitleCoverView(cover: title.cover)
                  .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                  .titleCoverStyle()

                let name = title.title!
                let qualifier = title.qualifier

                // The line limit with reserved spacing is enforced to align the titles (specifically the cover images)
                // vertically. A limit of 1 is compact and too short for many titles; a limit of 3 is too spacious and
                // still suseptible to longer titles; a limit of 2 catches many titles while missing some (e.g. "Made in
                // Abyss: The Golden City of the Scorching Sun"), but is "just right" for how much space it occupies.
                Group {
                  if let qualifier {
                    Text("\(name) \(Text(qualifier).foregroundColor(.secondary))")
                  } else {
                    Text(name)
                  }
                }
                .font(.callout)
                .bold()
                .lineLimit(2, reservesSpace: true)
                .help(title.name!)
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
      .navigationDestination(for: Navigation.self) { nav in
        switch nav {
          case .home: Self()
          case .title(let title): TitleView(title: title)
          case .content(let content): TContentView(content: content)
          case .entry(let entry): EntryView(entry: entry)
        }
      }.toolbar {
        // In the future, I'd like to provide users the ability to create or *import* titles (likely in some file format).
        // When that happens, this will likely be a Menu.
        CreateTitleButtonView()
      }
    }.onAppear {
      if let navigation {
        let decoder = JSONDecoder()

        if let nav = try? decoder.decode([Navigation].self, from: navigation) {
          self.navigator = nav
        }
      }
    }.onChange(of: navigator) { nav in
      let encoder = JSONEncoder()

      if let encoded = try? encoder.encode(nav) {
        navigation = encoded
      }
    }
  }
}
