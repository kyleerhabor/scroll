//
//  TitleView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/5/23.
//

import SwiftUI

struct TitleView: View {
  @Environment(\.managedObjectContext) private var viewContext

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
              .frame(width: width, height: titleCoverHeight(from: width))
              .titleCoverStyle()

//            VStack(spacing: 4) {
//              LabeledContent("Title", value: name)
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

        // Display contents here?
      }.padding()
    }
    // Looks better.
    #if os(macOS)
    .navigationTitle(name)
    #else
    .navigationSubtitle(name)
    #endif
    .toolbar {
      EditTitleButtonView(id: title.id)
      DeleteTitleButtonView(title: title)
    }
  }
}
