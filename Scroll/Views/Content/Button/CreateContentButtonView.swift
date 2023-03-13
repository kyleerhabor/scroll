//
//  CreateContentButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct CreateContentButtonView: View {
  @Environment(\.openWindow) private var openWindow

  private(set) var titleId: Title.ID

  var body: some View {
    Button {
      openWindow(id: "create-content-form", value: titleId)
    } label: {
      Label("Create Content", systemImage: "plus")
    }
  }
}

struct CreateContentButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateContentButtonView(titleId: .init(string: "/dev/null")!)
  }
}
