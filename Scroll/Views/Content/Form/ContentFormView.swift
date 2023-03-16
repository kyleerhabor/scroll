//
//  ContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct ContentFormView: View {
  private(set) var purpose: FormPurpose
  @Binding private(set) var title: String
  @Binding private(set) var kind: Content.Kind?
  @Binding private(set) var hours: Int
  @Binding private(set) var minutes: Int
  @Binding private(set) var seconds: Int
  @Binding private(set) var pages: Int
  private(set) var submit: () -> Void
  private(set) var cancel: () -> Void

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

  typealias MaybeKind = Content.Kind?

  var body: some View {
    Form {
      TextField("Title", text: $title)

      Picker("Kind", selection: $kind) {
        // Who the FUCK thought it was a good idea to require this for optional values?
        Text("None")
          .tag(nil as MaybeKind)

        Text("Episode")
          .tag(Content.Kind.episode as MaybeKind)

        Text("Chapter")
          .tag(Content.Kind.chapter as MaybeKind)
      }.pickerStyle(.inline)

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
    .navigationTitle(title(purpose: purpose))
  }

  func title(purpose: FormPurpose) -> String {
    switch purpose {
      case .create: return "Create Content"
      case .edit: return "Edit Content"
    }
  }

  func label(with purpose: FormPurpose) -> String {
    switch purpose {
      case .create: return "Create"
      case .edit: return "Save"
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
