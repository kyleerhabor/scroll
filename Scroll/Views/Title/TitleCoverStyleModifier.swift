//
//  TitleCoverStyleModifier.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/16/23.
//

import Foundation
import SwiftUI

struct TitleCoverStyleModifier: ViewModifier {
  static var defaultRadius: CGFloat = 4
  var radius = Self.defaultRadius

  func body(content: Self.Content) -> some View {
    content
      .clipped()
      .cornerRadius(radius)
      .shadow(radius: 2)
  }
  
  static func height(from width: CGFloat) -> CGFloat {
    width * (3 / 2)
  }
}

struct TitleCoverStyleModifier_Previews: PreviewProvider {
  static var previews: some View {
    let size: CGFloat = 128

    TitleCoverView()
      .frame(width: size, height: TitleCoverStyleModifier.height(from: size))
      .modifier(TitleCoverStyleModifier())
  }
}
