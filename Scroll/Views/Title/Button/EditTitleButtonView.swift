//
//  EditTitleButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct EditTitleButtonView: View {
  @Environment(\.openWindow) private var openWindow

  private(set) var id: Title.ID

  var body: some View {
    Button {
      openWindow(id: "edit-title-form", value: id)
    } label: {
      Label("Edit Title", systemImage: "pencil")
    }
  }
}

struct EditTitleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    EditTitleButtonView(id: .nullDevice)
  }
}
