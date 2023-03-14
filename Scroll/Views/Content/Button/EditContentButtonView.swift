//
//  EditContentButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct EditContentButtonView: View {
  @Environment(\.openWindow) private var openWindow

  private(set) var id: Content.ID

  var body: some View {
    Button {
      openWindow(id: "edit-content-form", value: id)
    } label: {
      Label("Edit Content", systemImage: "pencil")
    }
  }
}

struct EditContentButtonView_Previews: PreviewProvider {
  static var previews: some View {
    EditContentButtonView(id: .nullDevice)
  }
}
