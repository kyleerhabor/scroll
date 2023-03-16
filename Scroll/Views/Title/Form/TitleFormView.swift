//
//  TitleFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/13/23.
//

import SwiftUI

struct TitleFormView: View {
  private(set) var purpose: FormPurpose
  @Binding private(set) var title: String
  @Binding private(set) var cover: Data?
  @Binding private(set) var description: String
  @State private var importing = false
  private(set) var submit: () -> Void
  private(set) var cancel: () -> Void

  var body: some View {
    Form {
      HStack {
        VStack {
          let width: CGFloat = 128

          TitleCoverView(cover: cover)
            .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
            .titleCoverStyle()

          Button {
            importing = true
          } label: {
            Text("Select image")
          }.fileImporter(isPresented: $importing, allowedContentTypes: [.image]) { result in
            guard case let .success(img) = result else {
              return
            }

            cover = try? Data(contentsOf: img)
          }

          if cover != nil {
            Button(role: .cancel) {
              cover = nil
            } label: {
              Text("Remove")
            }
          }

          Text("2x3 dimensions")
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

      FormControlView(purpose: purpose, complete: isComplete(), submit: submit, cancel: cancel)
    }.padding()
  }

  func isComplete() -> Bool {
    !title.isEmpty
  }
}

struct TitleFormView_Previews: PreviewProvider {
  static var previews: some View {
    TitleFormView(
      purpose: .create,
      title: .constant("Crest of the Stars"),
      cover: .constant(nil),
      description: .constant("In the distant future, humanity is under attack by the Abh Empire, a race of advanced humanoid beings possessing vastly superior technology. As countless worlds fall to the Abh, mankind establishes the Four Nations Alliance—a resistance faction made up of the United Mankind, the Republic of Greater Alcont, the Federation of Hania, and the People's Sovereign of Union Planets.\n\nCrest of the Stars tells the story of Jinto Linn. When he was young, his father—the president of Martine—sold their world in exchange for a high position in the empire. Now a young count, Jinto must learn the ways of Abh nobility and live among those who subjugated his people. Helping him is Lafiel Abriel, an austere Abh princess whom Jinto quickly befriends. While traveling to Jinto's new school in the Abh homeland, their ship is caught in a violent space battle between the fleets of the Alliance and the Abh. Jinto and Abriel are thrust into the conflict, unaware that this skirmish marks the beginning of a full-scale war between the Abh Empire and mankind."),
      submit: noop,
      cancel: noop
    )
  }
}
