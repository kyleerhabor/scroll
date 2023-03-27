//
//  CreateListPlanButtonView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/26/23.
//

import SwiftUI

struct CreateListPlanButtonView: View {
  @Environment(\.openWindow) private var openWindow

  var contents: [Content.ID] = []

  var body: some View {
    Button {
      openWindow(id: "list-plan.create", value: contents)
    } label: {
      Label("Create List Plan", systemImage: "plus") // list.bullet.rectangle
    }
  }
}

struct CreateListPlanButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateListPlanButtonView()
  }
}
