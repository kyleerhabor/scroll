//
//  CreateEntryButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct CreateEntryButtonView: View {
  @Environment(\.openWindow) private var openWindow

  private(set) var titleId: Title.ID

  var body: some View {
    Button {
      openWindow(id: "create-entry-form", value: titleId)
    } label: {
      Label("Create Entry", systemImage: "plus")
    }
  }
}

struct CreateEntryButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateEntryButtonView(titleId: .nullDevice)
  }
}
