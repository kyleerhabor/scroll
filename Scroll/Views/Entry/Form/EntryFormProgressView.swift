//
//  EntryFormProgressView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/15/23.
//

import SwiftUI

struct EntryFormProgressView<Label>: View where Label: View {
  private(set) var progress: Double
  private(set) var total: Double
  @ViewBuilder private(set) var label: () -> Label

  var body: some View {
    ProgressView(value: progress, total: total) {
      // No title.
    } currentValueLabel: {
      label()
    }
  }
}

struct EntryFormProgressView_Previews: PreviewProvider {
  static var previews: some View {
    EntryFormProgressView(progress: 1, total: 2) {
      Text("...")
    }
  }
}
