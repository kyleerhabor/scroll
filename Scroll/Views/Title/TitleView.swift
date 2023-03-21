//
//  TitleView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/5/23.
//

import SwiftUI
import PhotosUI

struct TitleView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var title: Title

  @State private var name = ""
  @State private var qualifier = ""
  @State private var cover: Data?
  @State private var didErrorUpdatingTitle = false
  @State private var didErrorUpdatingCover = false
  @AppStorage("alwaysShowTitleQualifier") private var alwaysShowTitleQualifier = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .top) {
          let width: CGFloat = 160 // 128 * (5/4)

          VStack {
            ModifiableImageView(image: $cover, didError: $didErrorUpdatingCover) {
              TitleCoverView(cover: title.cover)
                .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                .titleCoverStyle()
            }
            .buttonStyle(.plain)
            .focusable(false)
            .onChange(of: title.cover) { cover in
              self.cover = cover
            }.onChange(of: cover) { cover in
              title.cover = cover

              if case .failure = viewContext.save() {
                didErrorUpdatingCover = true
              }
            }

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
            VStack(spacing: 1) { // 0 would feel weird to move the mouse across. 2 has a bit too much spacing.
              Group {
                TextField(text: $name, prompt: Text("Title"), axis: .vertical) {}
                  .font(.title)
                  .onSubmit {
                    let name = name.trimmingCharacters(in: .whitespacesAndNewlines)

                    guard !name.isEmpty else {
                      self.name = title.title!

                      return
                    }

                    guard name != title.title else {
                      return
                    }

                    title.title = name

                    if case .failure = viewContext.save() {
                      didErrorUpdatingTitle = true
                    }
                  }.onChange(of: title.title) { title in
                    self.name = title ?? ""
                  }

                if alwaysShowTitleQualifier || title.qualifier?.isEmpty == false {
                  TextField(text: $qualifier, prompt: Text("Qualifier"), axis: .vertical) {}
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .onSubmit {
                      let qualifier = qualifier.trimmingCharacters(in: .whitespacesAndNewlines)

                      guard qualifier != title.qualifier else {
                        return
                      }

                      title.qualifier = qualifier

                      if case .failure = viewContext.save() {
                        didErrorUpdatingTitle = true
                      }
                    }
                }
              }
              .focusable(false)
              .textFieldStyle(.plain)
              .bold()
              .onChange(of: title.qualifier) { qualifier in
                self.qualifier = qualifier ?? ""
              }
            }

            if let desc = title.desc {
              Text(desc)
                .textSelection(.enabled)
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
        }.focusable(false)
      }.padding()
    }
    .navigationTitle(title.title ?? "")
    .navigationSubtitle(title.qualifier ?? "")
    .toolbar {
      EditTitleButtonView(id: title.id)
      DeleteTitleButtonView(title: title)

      Menu {
        CreateContentButtonView(titleId: title.id)
      } label: {
        Label("Add", systemImage: "plus")
      }
    }
    .alert("Could not update title", isPresented: $didErrorUpdatingTitle) {}
    .alert("Could not update cover", isPresented: $didErrorUpdatingCover) {}
    .onAppear {
      name = title.title ?? ""
      qualifier = title.qualifier ?? ""
      cover = title.cover
    }
  }
}
