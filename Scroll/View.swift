//
//  View.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/10/23.
//

import Foundation
import SwiftUI

let titleCoverCornerRadius: CGFloat = 4

extension View {
  func titleCoverStyle() -> some View {
    clipped().cornerRadius(titleCoverCornerRadius)
  }
}

func titleCoverHeight(from width: CGFloat) -> CGFloat {
  width * (3 / 2)
}

struct TableLabeledContentStyle: LabeledContentStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
        .foregroundColor(.secondary)
      
      Spacer()
      configuration.content
    }
  }
}

extension LabeledContentStyle where Self == TableLabeledContentStyle {
  static var table: TableLabeledContentStyle { .init() }
}
