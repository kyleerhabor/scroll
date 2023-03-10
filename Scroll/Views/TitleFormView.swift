//
//  TitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/7/23.
//

import SwiftUI

struct TitleFormView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  @State private(set) var title = ""
  @State private(set) var cover: Data?
  @State private(set) var description: String = ""

  @State private var importingFile = false

  var body: some View {
    Form {
      HStack {
        VStack {
          TitleCoverView(cover: cover)
            .frame(width: 128, height: 128 * (4 / 3))

          Button {
            importingFile = true
          } label: {
            Text("Select image")
          }.fileImporter(isPresented: $importingFile, allowedContentTypes: [.image]) { result in
            guard case let .success(img) = result else {
              return
            }

            cover = try? Data(contentsOf: img)
          }

          Text("2 x 3 dimensions")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
        }

        VStack(alignment: .leading) {
          // For some reason, the text field stretches all the way.
          //
          // Maybe support multiple titles?
          TextField("Title:", text: $title)

          Text("Description:")

          // This still doesn't look right.
          TextEditor(text: $description)
            .font(.body)
        }
      }

      HStack {
        Spacer()

        Button("Cancel", role: .cancel) {
          dismiss()
        }

        Button("Create") {
          create()
          dismiss()
        }
        // I'd like to toggle between a regular and prominent button style, but the text does not toggle colors fast
        // enough, which creates a very short flash effect.
        .buttonStyle(.borderedProminent)
        .disabled(!isComplete())
      }
    }
    .padding()
    .navigationTitle("New Title")
  }

  func isComplete() -> Bool {
    !title.isEmpty
  }

  func create() {
    let ttl = Title(context: viewContext)
    ttl.title = title

    if !description.isEmpty {
      ttl.desc = description
    }

    ttl.cover = cover

    do {
      try viewContext.save()
    } catch let err {
      print(err)
    }
  }
}

struct TitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    TitleFormView(
      title: "Crest of the Stars",
      description: "In the distant future, humanity is under attack by the Abh Empire, a race of advanced humanoid beings possessing vastly superior technology. As countless worlds fall to the Abh, mankind establishes the Four Nations Alliance—a resistance faction made up of the United Mankind, the Republic of Greater Alcont, the Federation of Hania, and the People's Sovereign of Union Planets.\n\nCrest of the Stars tells the story of Jinto Linn. When he was young, his father—the president of Martine—sold their world in exchange for a high position in the empire. Now a young count, Jinto must learn the ways of Abh nobility and live among those who subjugated his people. Helping him is Lafiel Abriel, an austere Abh princess whom Jinto quickly befriends. While traveling to Jinto's new school in the Abh homeland, their ship is caught in a violent space battle between the fleets of the Alliance and the Abh. Jinto and Abriel are thrust into the conflict, unaware that this skirmish marks the beginning of a full-scale war between the Abh Empire and mankind."
    )
  }
}
