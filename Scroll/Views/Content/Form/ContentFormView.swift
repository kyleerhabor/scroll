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

  private let numberFormatter = {
    let formatter = NumberFormatter()
    formatter.allowsFloats = false
    formatter.minimum = 0

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
        TextField("Hours", value: $hours, formatter: numberFormatter)

        TextField("Minutes", value: $minutes, formatter: numberFormatter)

        TextField("Seconds", value: $seconds, formatter: numberFormatter)
      }.disabled(kind != .episode)

      Section("Chapter") {
        TextField("Pages", value: $pages, formatter: numberFormatter)
          .disabled(kind != .chapter)
      }

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
