//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State private var sidebar: Navigation = .titles
  @State private var path: [Navigation] = []
  @SceneStorage("navigation") private var navigation: Data?

  var body: some View {
    // I wanted to use a NavigationStack inside a NavigationSplitView, but navigating more than one layer deep causes
    // the app to freeze with high CPU usage and eventually crash. Apparently it's been fixed in macOS 13.3, but that'll
    // only make the app practically available for bleeding-edge users, which will suck.
    NavigationStack {
      TabView {
        TitlesView().tabItem {
          Label("Titles", systemImage: "t.square")
        }

        ListsView().tabItem {
          Label("Lists", systemImage: "list.bullet")
        }
      }.navigationDestination(for: Navigation.self) { nav in
        switch nav {
          case .titles: TitlesView()
          case .lists: ListsView()
          case .title(let title): TitleView(title: title)
          case .content(let content): TContentView(content: content)
          case .entry(let entry): EntryView(entry: entry)
        }
      }
    }.onAppear {
      if let navigation {
        let decoder = JSONDecoder()

        if let path = try? decoder.decode([Navigation].self, from: navigation) {
          self.path = path
        }
      }
    }.onChange(of: path) { path in
      let encoder = JSONEncoder()

      if let encoded = try? encoder.encode(path) {
        navigation = encoded
      }
    }
  }
}
