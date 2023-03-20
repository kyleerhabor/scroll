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

  // TODO: Add title qualifiers to model.
  @ObservedObject var title: Title

  @State private var name: String
  @State private var coverPhotos: [PhotosPickerItem] = []
  @State private var isPresentingCoverPicker = false
  @State private var isPresentingCoverFilePrompt = false
  @State private var isPresentingCoverPhotoPrompt = false
  @State private var isPresentingDeletePrompt = false
  @State private var isHoveringOnCover = false
  @State private var didErrorUpdatingTitle = false
  @State private var didErrorUpdatingCover = false

  var body: some View {
    let name = title.title!

    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .top) {
          let width: CGFloat = 160 // 128 * (5/4)

          VStack {
            Button {
              isPresentingCoverPicker = true
            } label: {
              // I experimented adding a stroked hover on hover and thought it was worse.
              TitleCoverView(cover: title.cover)
                .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
                .titleCoverStyle()
                // 0.625 - x - 0.75
                .opacity(isHoveringOnCover ? 0.6875 : 1)
                .onHover { isHovering in
                  isHoveringOnCover = isHovering
                }.popover(isPresented: $isPresentingCoverPicker, arrowEdge: .trailing) {
                  HStack {
                    Button("Files") {
                      isPresentingCoverFilePrompt = true
                    }
                    
                    Button("Photos") {
                      isPresentingCoverPhotoPrompt = true
                    }

                    Button(role: .destructive) {
                      title.cover = nil

                      if case .failure = viewContext.save() {
                        didErrorUpdatingCover = true
                      }
                    } label: {
                      Image(systemName: "clear")
                    }
                  }.padding()
                }.fileImporter(isPresented: $isPresentingCoverFilePrompt, allowedContentTypes: [.image]) { result in
                  guard case let .success(image) = result,
                        let data = try? Data(contentsOf: image) else {
                    didErrorUpdatingCover = true

                    return
                  }

                  title.cover = data

                  if case .failure = viewContext.save() {
                    didErrorUpdatingCover = true
                  }
                }.photosPicker(
                  isPresented: $isPresentingCoverPhotoPrompt,
                  selection: $coverPhotos,
                  maxSelectionCount: 1,
                  matching: .images
                ).onDrop(of: [.image], isTargeted: $isHoveringOnCover) { providers in
                  _ = providers.first?.loadDataRepresentation(for: .image) { data, err in
                    // There better be a better way to do this.
                    DispatchQueue.main.async {
                      guard let data else {
                        didErrorUpdatingCover = true

                        return
                      }

                      title.cover = data

                      if case .failure = viewContext.save() {
                        didErrorUpdatingCover = true
                      }
                    }
                  }

                  return true
                }.animation(.default, value: isHoveringOnCover)
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
            TextField(text: $name, prompt: Text("Title")) {}
              .focusable(false)
              .textFieldStyle(.plain)
              .font(.title)
              .bold()
              .onSubmit {
                let name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !name.isEmpty else {
                  self.name = title.title!

                  return
                }

                guard name != title.title else {
                  return
                }

                title.title = self.name

                if case .failure = viewContext.save() {
                  didErrorUpdatingTitle = true
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
    .alert("Could not update title", isPresented: $didErrorUpdatingTitle) {}
    .alert("Could not update cover", isPresented: $didErrorUpdatingCover) {}
    .onChange(of: coverPhotos) { photos in
      photos.first!.loadTransferable(type: Data.self) { result in
        guard case let .success(cover) = result,
              let cover else {
          didErrorUpdatingCover = true

          return
        }

        title.cover = cover

        if case .failure = viewContext.save() {
          didErrorUpdatingCover = true
        }
      }
    }
  }

  init(title: Title) {
    self.title = title
    self.name = title.title!
  }
}
