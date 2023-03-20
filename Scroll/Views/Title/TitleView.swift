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
  @State private var isPresentingDeletePrompt = false
  @State private var isHoveringCover = false

  var body: some View {
    let name = self.title.title!

    Form {
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          HStack(alignment: .top) {
            let width: CGFloat = 160 // 128 * (5/4)

            VStack {
              TitleCoverView(cover: self.title.cover)
                .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                .titleCoverStyle()
                .onDrop(of: [.image], isTargeted: $isHoveringCover) { provider in
                  provider.first?.loadDataRepresentation(for: .image) { data, err in
                    if let data {
                      // There better be a better way to do this.
                      DispatchQueue.main.async {
                        self.title.cover = data
                      }
                    }
                  }

                  return true
                }
                .onHover { active in
                  withAnimation {
                    self.isHoveringCover = active
                  }
                }

              if self.isHoveringCover {
                Text("Drop it liked it's hot!")
              }

              //            VStack(spacing: 4) {
              //
              //            }
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
        }
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
