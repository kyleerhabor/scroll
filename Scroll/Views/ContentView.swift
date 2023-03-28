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

  var body: some View {
    NavigationSplitView {
      List(selection: $sidebar) {
        NavigationLink(value: Navigation.titles) {
          Label("Titles", systemImage: "t.square")
        }

        NavigationLink(value: Navigation.lists) {
          Label("Lists", systemImage: "list.bullet.rectangle")
        }
      }
    } detail: {
      NavigationStack {
        ScrollView {
          Group {
            switch sidebar {
              case .titles: TitlesView()
              case .lists: ListsView()
              default: EmptyView()
            }
          }.scenePadding()
        }.navigationDestination(for: Navigation.self) { nav in
          switch nav {
            case .titles: TitlesView()
            case .lists: ListsView()
            case .title(let title): TitleView(title: title)
            case .content(let content): TContentView(content: content)
            case .entry(let entry): EntryView(entry: entry)
          }
        }.toolbar {
          Menu {
            CreateTitleButtonView()
            CreateListPlanButtonView()
          } label: {
            Label("Create", systemImage: "plus")
          }
        }
      }
    }
  }
}
