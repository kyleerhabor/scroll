//
//  DataView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/17/23.
//

import SwiftUI

struct DataView<Content, Hidden, T>: View where Content: View, Hidden: View {
  typealias ContentSignature = (T) -> Content
  typealias HiddenSignature = () -> Hidden
  typealias TSignature = () -> T?

  var content: ContentSignature
  var hidden: HiddenSignature
  var load: TSignature
  @State private var data: T?

  var body: some View {
    if let data {
      content(data)
    } else {
      hidden().onAppear {
        if let data = self.load() {
          self.data = data
        }
      }
    }
  }

  init(
    @ViewBuilder content: @escaping ContentSignature,
    @ViewBuilder hidden: @escaping HiddenSignature,
    loading: @escaping TSignature
  ) {
    self.content = content
    self.hidden = hidden
    self.load = loading
  }
}

struct DataView_Previews: PreviewProvider {
  static var previews: some View {
    DataView { num in
      Text("\(num)!!!")
    } hidden: {
      HiddenView()
    } loading: {
      5
    }
  }
}
