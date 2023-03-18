//
//  EntryFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/17/23.
//

import SwiftUI

struct EntryFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  var purpose: FormPurpose
  @ObservedObject var entry: Entry

  @SceneStorage("notes") private var notes: String = ""
  @State private var didErrorOnSubmit = false

  var body: some View {
    Form {
      let content = entry.content!

      if let kind = content.kind {
        Section("Progress") {
          switch kind {
            case .episode:
              if let episode = content.episode, episode.duration > 0 {
                EntryFormEpisodeView(entry: entry)
              }
            case .chapter:
              if let chapter = content.chapter, chapter.pages > 0 {
                EntryFormChapterView(entry: entry)
              }
          }
        }
      }

      Section("Notes") {
        // TextEditor looks worse (at least, on macOS), though this may be visually confusing.
        TextField("Notes", text: $notes, prompt: Text("..."), axis: .vertical)
          .labelsHidden()
      }

      FormControlView(purpose: purpose, complete: true) {
        do {
          try viewContext.save()
          dismiss()
        } catch let err {
          print(err)

          didErrorOnSubmit = true
        }
      } cancel: {
        viewContext.rollback()
        dismiss()
      }
    }
    .formStyle(.grouped)
    .navigationTitle(titleLabel())
    .navigationSubtitle(entry.content!.title!)
    .alert(submitErrorLabel(), isPresented: $didErrorOnSubmit) {}
    .onChange(of: notes) { notes in
      entry.notes = notes
    }
  }

  func titleLabel() -> String {
    switch purpose {
      case .create: return "Create Entry"
      case .edit: return "Edit Entry"
    }
  }

  func submitErrorLabel() -> String {
    switch purpose {
      case .create: return "Could not create entry."
      case .edit: return "Could not edit entry."
    }
  }
}

struct EntryFormView_Previews: PreviewProvider {
  static private var context = CoreDataStack.preview.container.viewContext
  static private var entry: Entry = {
    let entry = Entry(context: context)
    entry.notes = "Hmm..."

    let content = Content(context: context)
    content.title = "Surprise Attack"
    content.kind = .episode
    content.addToEntries(entry)

    let episode = Episode(context: context)
    episode.duration = .init(DateComponents(minute: 25, second: 7).seconds())
    episode.content = content

    let eEpisode = EntryEpisode(context: context)
    eEpisode.progress = .init(DateComponents(minute: 2, second: 59).seconds())
    eEpisode.entry = entry

    return entry
  }()

  static var previews: some View {
    EntryFormView(purpose: .create, entry: entry)
  }
}
