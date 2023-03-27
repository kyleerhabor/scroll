//
//  TContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct TContentView: View { // T[itle]ContentView to not conflict with ContentView
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var content: Content

  @State private var title = ""
  @State private var didErrorUpdatingTitle = false

  var body: some View {
    let title = content.title ?? ""

    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        TextField("Title", text: $title, prompt: Text("Title"))
          .textFieldStyle(.plain)
          .font(.title)
          .bold()
          .textSelection(.enabled)
          .onSubmit {
            let name = self.title.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !name.isEmpty else {
              self.title = title

              return
            }

            guard name != title else {
              return
            }

            content.title = name

            if case .failure = viewContext.save() {
              didErrorUpdatingTitle = true
            }
          }

        VStack(alignment: .leading, spacing: 4) {
          Group {
            if let kind = content.kind {
              switch kind {
                case .episode:
                  if let duration = content.episode?.duration {
                    let dur = Duration.seconds(duration)

                    Text(dur.formatted(.time(pattern: dur.pattern())))
                  }
                case .chapter:
                  if let pages = content.chapter?.pages {
                    Text(pages == 1 ? "\(pages) page" : "\(pages) pages")
                  }
              }
            }
          }
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.secondary)
          .textSelection(.enabled)

          if let description = content.desc {
            // TODO: Add a line limit which displays a "show more" text if exceeded (like DisclosureGroup, but better).
            Text(description)
              .textSelection(.enabled)
          }

          if let total = content.entries?.count, total > 0 {
            Text("Entries")
              .font(.title2)
              .fontWeight(.semibold)

            ContentEntriesView(content: content)
              .listStyle(.plain)
              .frame(height: CGFloat(total) * 24)
          }
        }
      }.padding()
    }
    .navigationTitle(title)
    .navigationSubtitle(content.titleRef?.name ?? "")
    .toolbar {
      EditContentButtonView(id: content.id)
      DeleteContentButtonView(content: content)

      Menu {
        CreateListPlanButtonView(contents: [content.id])
      } label: {
        Label("Create", systemImage: "plus")
      }
    }
    .alert("Could not update title.", isPresented: $didErrorUpdatingTitle) {}
    .onAppear {
      self.title = title
    }
  }
}

struct TContentView_Previews: PreviewProvider {
  static private let viewContext = CoreDataStack.preview.container.viewContext
  static private let content: Content = {
    let content = Content(context: viewContext)
    content.title = "Invasion"
    // Add some more stuff later.

    return content
  }()

  static var previews: some View {
    TContentView(content: content)
  }
}
