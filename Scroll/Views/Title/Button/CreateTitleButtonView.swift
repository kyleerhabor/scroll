//
//  CreateTitleButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct CreateTitleButtonView: View {
  @Environment(\.openWindow) private var openWindow

  var body: some View {
    Button {
      openWindow(id: "create-title-form")
    } label: {
      Label("Create Title", systemImage: "plus")
    }
  }
}

struct CreateTitleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateTitleButtonView()
  }
}
