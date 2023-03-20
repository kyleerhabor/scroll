//
//  TitleView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/5/23.
//

import SwiftUI

struct TitleView: View {
  @Environment(\.managedObjectContext) private var viewContext

  // TODO: Add title qualifiers to model.
  private(set) var title: Title

  @State private var isPresentingDeletePrompt = false

  var body: some View {
    let name = title.title ?? "..."

    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .top) {
          let width: CGFloat = 160 // 128 * (5/4)

          VStack {
            TitleCoverView(cover: title.cover)
              .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
              .titleCoverStyle()

//            VStack(spacing: 4) {
//
//            }
          }
          .frame(width: width)
          .labeledContentStyle(.table)
          .font(.callout)

          VStack(alignment: .leading) {
            Text(name)
              .font(.title)
              .fontWeight(.medium)

            if let desc = title.desc {
              Text(desc)
            }
          }
        }

        Divider()

        // On macOS, I'd prefer this be a LazyVGrid where the items dictate their size, as opposed to the columns.
        HStack {
          Group {
            if title.contents?.isEmpty == false {
              NavigationLink(value: Navigation.contents(title)) {
                GroupBox {
                  Text("Contents")
                    .font(.title3)
                }
              }
            }
          }.buttonStyle(.plain)
        }
      }
    }
    .padding()
    // Looks better.
    #if os(macOS)
    .navigationTitle(name)
    #else
    .navigationSubtitle(name)
    #endif
    .toolbar {
      EditTitleButtonView(id: title.id)
      DeleteTitleButtonView(title: title)

      Menu {
        CreateContentButtonView(titleId: title.id)
      } label: {
        Label("Add", systemImage: "plus")
      }
    }
  }
}
