//
//  HiddenView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/17/23.
//

import SwiftUI

struct HiddenView: View {
  var body: some View {
    // EmptyView does not work when paired with .onAppear. Why Rectangle? Just felt like it.
    Rectangle()
      .hidden()
  }
}

struct HiddenView_Previews: PreviewProvider {
  static var previews: some View {
    HiddenView()
  }
}
