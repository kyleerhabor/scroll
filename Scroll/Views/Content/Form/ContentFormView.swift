//
//  ContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct ContentFormView: View {
  var purpose: FormPurpose
  @Binding var title: String
  @Binding var description: String
  @Binding var kind: Content.Kind?
  @Binding var hours: Int
  @Binding var minutes: Int
  @Binding var seconds: Int
  @Binding var pages: Int
  var submit: () -> Void
  var cancel: () -> Void

  private let durationFormatter = {
    let formatter = NumberFormatter()
    formatter.allowsFloats = false
    formatter.minimum = 0
    formatter.maximum = NSNumber(value: Int32.max)

    return formatter
  }()

  private let pagesFormatter = {
    let formatter = NumberFormatter()
    formatter.allowsFloats = false
    formatter.minimum = 0
    formatter.maximum = NSNumber(value: Int16.max)

    return formatter
  }()

  typealias Kind = Content.Kind

  var body: some View {
    Form {
      TextField("Title", text: $title)

      Picker("Kind", selection: $kind) {
        Text("None")
          .tag(nil as Kind?)

        Text("Episode")
          .tag(Kind.episode as Kind?)

        Text("Chapter")
          .tag(Kind.chapter as Kind?)
      }.pickerStyle(.inline)

      Section {
        TextEditor(text: $description)
      } header: {
        Text("Description")
        Text(descriptionLabel())
      }

      Section("Episode") {
        // Creating a Stepper with a format of .timeDuration seems to trigger some form configuration error.

        TextField("Hours", value: $hours, formatter: durationFormatter)

        TextField("Minutes", value: $minutes, formatter: durationFormatter)

        TextField("Seconds", value: $seconds, formatter: durationFormatter)
      }.disabled(kind != .episode)

      Section("Chapter") {
        // I'd like to use a stepper with a format of .number, but it:
        // - requires a double
        // - allows invalid inputs (e.g. negatives)
        // - appears to be buggy.
        //
        // The main benefit to a stepper is it's more platform aware (e.g. showing a text field and vertical stepper on
        // macOS), but on other platforms, it would likely still be a bad idea, since a chapter could have many pages
        // (e.g. 80), requiring a long time to press/hold to the number.
        TextField("Pages", value: $pages, formatter: pagesFormatter)
      }.disabled(kind != .chapter)

      FormControlView(purpose: purpose, complete: isComplete(), submit: submit, cancel: cancel)
    }
    .formStyle(.grouped)
    .navigationTitle(titleLabel(for: purpose))
  }

  func titleLabel(for purpose: FormPurpose) -> String {
    switch purpose {
      case .create: return "Create Content"
      case .edit: return "Edit Content"
    }
  }

  func descriptionLabel() -> String {
    guard let kind else {
      return "An overview or summary of the content."
    }

    switch kind {
      case .episode: return "An overview or summary of the episode."
      case .chapter: return "An overview or summary of the chapter."
    }
  }

  func isComplete() -> Bool {
    !title.isEmpty
  }
}

struct ContentFormView_Previews: PreviewProvider {
  static var previews: some View {
    ContentFormView(
      purpose: .create,
      title: .constant("Invasion"),
      // https://en.wikipedia.org/wiki/Crest_of_the_Stars#Anime #1
      description: .constant("The ever-expanding Abh Empire of Mankind, led by the Dusanyo, invades the Hyde Star System. It becomes clear that direct governance of the surface world is not part of their plans. In exchange for allowing its citizens the right to freely travel to other star systems as well as elect the territorial lord from amongst themselves, Rock Lynn, who was then the president, surrenders their sovereignty. But he did not consult his immediate subordinates, not even his friend and executive secretary Teal Clint, who also served as surrogate parent for his son. And so, although he earned an Abh nobility for his family, he left everyone else feelinng betrayed. Years later, having spent several years on the planet Delktoe learning to read and write in Baronh, the Abh language, Jinto takes up his status as a noble and is on his way to the capital to attend military school."),
      kind: .constant(.episode),
      hours: .constant(0),
      minutes: .constant(25),
      seconds: .constant(5),
      pages: .constant(0),
      submit: noop,
      cancel: noop
    )
  }
}
