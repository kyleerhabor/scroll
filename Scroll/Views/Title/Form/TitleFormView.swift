//
//  TitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/20/23.
//

import SwiftUI

struct TitleFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var title: Title
  var purpose: FormPurpose

  @State private var didError = false
  @State private var didErrorUpdatingCover = false
  @State private var coverViewContext: NSManagedObjectContext?

  var body: some View {
    Form {
      TextField("Name", text: $title.uiTitle)

      TextField(text: $title.uiQualifier) {
        Text("Qualifier")
        Text("An identifier to help disambiguate against titles with similar names.")
      }

      LabeledContent {
        Button("Cover") {
          coverViewContext = viewContext.child()
        }.sheet(item: $coverViewContext) { context in
          TitleFormCoverView(title: title)
            .foregroundColor(.primary)
            .environment(\.managedObjectContext, context)
        }
      } label: {
        Text("Cover")
        Text("Should be 2x3 dimensions.")
      }

      Section {
        TextEditor(text: $title.uiDescription)
      } header: {
        Text("Description")
        Text("A basic, descriptive overview of the title.")
      }

      FormControlView(purpose: purpose, complete: isComplete()) {
        title.uiTitle = title.uiTitleLabel
        title.uiQualifier = title.uiQualifier.trimmingCharacters(in: .whitespacesAndNewlines)
        title.uiDescription = title.uiDescription.trimmingCharacters(in: .whitespacesAndNewlines)

        guard case .success = viewContext.save() else {
          didError = true

          return
        }

        dismiss()
      } cancel: {
        viewContext.rollback()
        dismiss()
      }.alert(submitLabel(), isPresented: $didError) {}
    }
    .formStyle(.grouped)
    .navigationTitle(titleLabel())
  }

  func titleLabel() -> String {
    switch purpose {
      case .create: return "Create Title"
      case .edit: return "Edit Title"
    }
  }

  func submitLabel() -> String {
    switch purpose {
      case .create: return "Could not create title."
      case .edit: return "Could not edit title."
    }
  }

  func isComplete() -> Bool {
    !title.uiTitleLabel.isEmpty
  }
}

struct TitleFormView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let title: Title = {
    let title = Title(context: context)
    title.title = "Crest of the Stars"
    title.qualifier = "Anime"
    title.desc = "In the distant future, humanity is under attack by the Abh Empire, a race of advanced humanoid beings possessing vastly superior technology. As countless worlds fall to the Abh, mankind establishes the Four Nations Alliance—a resistance faction made up of the United Mankind, the Republic of Greater Alcont, the Federation of Hania, and the People's Sovereign of Union Planets.\n\nCrest of the Stars tells the story of Jinto Linn. When he was young, his father—the president of Martine—sold their world in exchange for a high position in the empire. Now a young count, Jinto must learn the ways of Abh nobility and live among those who subjugated his people. Helping him is Lafiel Abriel, an austere Abh princess whom Jinto quickly befriends. While traveling to Jinto's new school in the Abh homeland, their ship is caught in a violent space battle between the fleets of the Alliance and the Abh. Jinto and Abriel are thrust into the conflict, unaware that this skirmish marks the beginning of a full-scale war between the Abh Empire and mankind."

    return title
  }()

  static var previews: some View {
    TitleFormView(title: title, purpose: .create)
  }
}
