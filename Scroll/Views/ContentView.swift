//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View { 
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          GroupBox {
            ListsView()
              .frame(maxWidth: .infinity)
          } label: {
            Text("List")
              .font(.title2)
              .fontWeight(.semibold)
          }

          GroupBox {
            TitlesView()
              .frame(maxWidth: .infinity)
          } label: {
            Text("Titles")
              .font(.title2)
              .fontWeight(.semibold)
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
