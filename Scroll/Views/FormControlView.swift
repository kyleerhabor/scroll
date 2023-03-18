//
//  FormControlView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/13/23.
//

import SwiftUI

// Looks out of place in a grouped form.
struct FormControlView: View {
  private(set) var purpose: FormPurpose
  private(set) var complete: Bool
  private(set) var submit: SideEffect
  private(set) var cancel: SideEffect

  var body: some View {
    HStack {
      Spacer()

      Button("Cancel", role: .cancel) {
        cancel()
      }.keyboardShortcut(.cancelAction)

      Button(submitLabel(with: purpose)) {
        submit()
      }
      .keyboardShortcut(.defaultAction)
      .disabled(!complete)
    }
  }

  func submitLabel(with purpose: FormPurpose) -> String {
    switch purpose {
      case .create: return "Create"
      case .edit: return "Save"
    }
  }
}

struct FormControlView_Previews: PreviewProvider {
  static var previews: some View {
    FormControlView(
      purpose: .create,
      complete: true,
      submit: noop,
      cancel: noop
    )
  }
}
