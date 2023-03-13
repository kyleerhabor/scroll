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

  private(set) var submit: () -> Void
  private(set) var cancel: () -> Void

  var body: some View {
    Form {
      TextField("Title:", text: $title)

      HStack {
        Spacer()

        Button("Cancel", role: .cancel, action: cancel)
        Button(label(with: purpose), action: submit)
          .buttonStyle(.borderedProminent)
          .disabled(!isComplete())
      }
    }
    .padding()
    .navigationTitle(title(with: purpose))
  }

  func title(with purpose: FormPurpose) -> String {
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
      submit: noop,
      cancel: noop
    )
  }
}
