//
//  TitleView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/5/23.
//

import SwiftUI

struct TitleView: View {
  @Environment(\.openWindow) private var openWindow

  private(set) var title: Title

  var body: some View {
    let name = title.title!

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
      Button {
        openWindow(id: "title-form", value: title.id)
      } label: {
        Label("Edit", systemImage: "pencil")
      }
    }
  }
}
