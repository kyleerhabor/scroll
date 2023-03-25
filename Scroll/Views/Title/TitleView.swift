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

            VStack(spacing: 4) {
              if let contents = title.contents {
                let kinds = Dictionary(grouping: contents, by: \.kind)

                if let count = kinds[.episode]?.count, count > 0 {
                  LabeledContent("Episodes", value: "\(count)")
                }

                if let count = kinds[.chapter]?.count, count > 0 {
                  LabeledContent("Chapters", value: "\(count)")
                }

                if let count = kinds[nil]?.count, count > 0 {
                  LabeledContent("Content (None)", value: "\(count)")
                }
              }
            }
            .labeledContentStyle(.table)
            .font(.callout)
            .padding(.horizontal, 4)
          }
          .frame(width: width)

          VStack(alignment: .leading) {
            VStack(spacing: 1) {
              Group {
                TextField("Title", text: $name, prompt: Text("Title"), axis: .vertical)
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
                  }

                if alwaysShowTitleQualifier || title.qualifier?.isEmpty == false {
                  TextField("Qualifier", text: $qualifier, prompt: Text("Qualifier"), axis: .vertical)
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
            }

            if let desc = title.desc {
              Text(desc)
                .textSelection(.enabled)
            }
          }
        }

        Divider()

        if let total = title.contents?.count, total > 0 {
          Text("Contents")
            .font(.title2)
            .fontWeight(.semibold)

          TitleContentsView(title: title)
            .listStyle(.plain)
            .frame(height: min(CGFloat(total * 24), 12 * 24)) // At most, ~12
            .cornerRadius(6)
        }
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
    }.onChange(of: cover) { cover in
      title.cover = cover

      if case .failure = viewContext.save() {
        didErrorUpdatingCover = true
      }
    }.onChange(of: title.title) { title in
      self.name = title ?? ""
    }.onChange(of: title.qualifier) { qualifier in
      self.qualifier = qualifier ?? ""
    }.onChange(of: title.cover) { cover in
      self.cover = cover
    }
  }
}

struct TitleView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let title: Title = {
    let title = Title(context: context)
    title.title = "Crest of the Stars"

    return title
  }()

  static var previews: some View {
    TitleView(title: title)
  }
}
