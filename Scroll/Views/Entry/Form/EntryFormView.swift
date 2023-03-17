//
//  EntryFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

// I think the whole design of an entry here is flawed. The current design is that an entry represents a title consumed
// by a set of its content. To put that more concretely, an entry is associated with a title and its contents. A major
// limitation is that the content is a set, meaning that a user could not consume a single content multiple times. I've
// always had mixed feelings about this design, but originally kept it since I thought of the "common way" people record
// their titles.
//
// Another major reason I'm considering the design a mistake is how it requires the code to be structured. As an entry
// represents a consumed set of the content in a title, an entry must represent internally many things. This has caused
// me to think much about how I'd handle a variable amount of content being listed and modified in an e.g. create screen,
// which is something very hard for me to model without resorting to inline Binding constructions (as my previous
// project, Clematis, did) with indicies or a dedicated view model (which is unnecessary 95% of the time and would still
// be complex, figuring out how to pair state with just details).
//
// As an improved version, I think an entry should represent consumed content. So, a single content can be consumed a
// variable set of times. To actually bundle them togerher, I need a concept which represents a collection of entries.
// I don't know if that content should be constrained to the title or allowed to overlap. I think the former would be
// more appropriate for the problem, while the latter would be better for describing a kind of "list".
struct EntryFormView: View {
  var purpose: FormPurpose
  var title: Title?
  @Binding var name: String
  @Binding var notes: String
  var submit: () -> Void
  var cancel: () -> Void

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
          // Looks bad (on macOS).
          TextEditor(text: $notes)
            .font(.body)
        }

        FormControlView(purpose: purpose, complete: title != nil, submit: submit, cancel: cancel)
      }
      .formStyle(.grouped)
      .navigationTitle(titleLabel())
      .navigationSubtitle(title?.title ?? "")
      .navigationDestination(for: Content.self) { content in
        Text("...")
          .navigationSubtitle(title?.title ?? "")
      }
    }
  }

  func submitLabel() -> String {
    switch purpose {
      case .create: return "Create"
      case .edit: return "Save"
    }
  }

  func titleLabel() -> String {
    switch self.purpose {
      case .create: return "Create Entry"
      case .edit: return "Edit Entry"
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

