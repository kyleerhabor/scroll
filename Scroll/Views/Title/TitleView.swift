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
  @ObservedObject var title: Title

  @State private var name: String
  @State private var isPresentingCoverPicker = false
  @State private var isPresentingDeletePrompt = false
  @State private var isHoveringCover = false

  var body: some View {
    let name = self.title.title!

    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .top) {
          let width: CGFloat = 160 // 128 * (5/4)

          VStack {
            Button {
              isPresentingCoverPicker = true
            } label: {
              // I experimented adding a stroked hover on hover and thought it was worse.
              TitleCoverView(cover: self.title.cover)
                .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                .titleCoverStyle()
                .opacity(self.isHoveringCover ? 0.5 : 1)
                .onHover { isHovering in
                  self.isHoveringCover = isHovering
                }.fileImporter(isPresented: $isPresentingCoverPicker, allowedContentTypes: [.image]) { result in
                  if case let .success(image) = result {
                    if let data = try? Data(contentsOf: image) {
                      self.title.cover = data
                    }
                  }
                }.onDrop(of: [.image], isTargeted: $isHoveringCover) { providers in
                  providers.first?.loadDataRepresentation(for: .image) { data, err in
                    if let data {
                      // There better be a better way to do this.
                      DispatchQueue.main.async {
                        self.title.cover = data
                      }
                    }
                  }

                  return true
                }.animation(.default, value: self.isHoveringCover)
            }
            .buttonStyle(.plain)
            .focusable(false)

            VStack(spacing: 4) {
              if let contents = title.contents {
                let kinds = Dictionary(grouping: contents, by: \.kind)

                if let count = kinds[nil]?.count, count > 0 {
                  LabeledContent("Content", value: "\(count)")
                }

                if let count = kinds[.episode]?.count, count > 0 {
                  LabeledContent("Episodes", value: "\(count)")
                }

                if let count = kinds[.chapter]?.count, count > 0 {
                  LabeledContent("Chapters", value: "\(count)")
                }
              }
            }
            .padding(.horizontal, 4)
            .labeledContentStyle(.table)
          }
          .frame(width: width)
          .labeledContentStyle(.table)
          .font(.callout)

          VStack(alignment: .leading) {
            TextField(text: $name) {}
              .focusable(false)
              .textFieldStyle(.plain)
              .font(.title)
              .onSubmit {
                if self.name != self.title.title {
                  self.title.title = self.name
                }

                do {
                  try viewContext.save()
                } catch let err {
                  print(err)
                }
              }

            if let desc = self.title.desc {
              Text(desc)
            }
          }
        }

        Divider()

        // On macOS, I'd prefer this be a LazyVGrid where the items dictate their size, as opposed to the columns.
        HStack {
          Group {
            if self.title.contents?.isEmpty == false {
              NavigationLink(value: Navigation.contents(self.title)) {
                GroupBox {
                  Text("Contents")
                    .font(.title3)
                }
              }
            }
          }.buttonStyle(.plain)
        }.focusable(false)
      }.padding()
    }
    // Looks better.
    #if os(macOS)
    .navigationTitle(name)
    #else
    .navigationSubtitle(name)
    #endif
    .toolbar {
      EditTitleButtonView(id: self.title.id)
      DeleteTitleButtonView(title: self.title)

      Menu {
        CreateContentButtonView(titleId: self.title.id)
      } label: {
        Label("Add", systemImage: "plus")
      }
    }
}

init(title: Title) {
  self.title = title
  self.name = title.title!
}
}
