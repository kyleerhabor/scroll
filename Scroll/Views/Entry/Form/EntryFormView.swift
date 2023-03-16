//
//  EntryFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct EntryFormView: View {
  private(set) var purpose: FormPurpose
  private(set) var title: Title?
  @Binding private(set) var name: String
  @Binding private(set) var notes: String
  private(set) var submit: () -> Void
  private(set) var cancel: () -> Void

  @State private var progress: Double = 12

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField(text: $name) {
            Text("Name")
            Text("A custom label to help remember this entry.")
          }
        }

        if let contents = title?.contents {
          Section("Content") {
            ForEach(Array(contents), id: \.id) { content in
              NavigationLink(value: content) {
                LabeledContent("\(content.title!)") {
                  // Ideally, I'd inline this, but the Swift compiler is too dumb to process it.
                  EntryFormContentView(content: content)
                }
              }
            }
          }
        }

        Section("Notes") {
          // Looks bad on macOS
          TextEditor(text: $notes)
            .font(.body)
        }

        FormControlView(purpose: purpose, complete: true, submit: submit, cancel: cancel)
      }
      .formStyle(.grouped)
      .navigationSubtitle(title?.title ?? "")
      .navigationDestination(for: Content.self) { content in
        Text("...")
          .navigationSubtitle(title?.title ?? "")
      }
    }
  }
}

struct EntryFormView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let title: Title = {
    let title = Title(context: context)
    title.title = "Banner of the Stars"

    return title
  }()

  static var previews: some View {
    EntryFormView(
      purpose: .create,
      title: title,
      name: .constant("First, naive watch"),
      notes: .constant("The world-building is fantastic."),
      submit: noop,
      cancel: noop
    ).environment(\.managedObjectContext, context)
  }
}

