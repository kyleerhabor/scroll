//
//  View.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/10/23.
//

import Foundation
import SwiftUI

extension View {
  func titleCoverStyle() -> some View {
    self.modifier(TitleCoverStyleModifier())
  }
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

enum FormPurpose {
  case create, edit
}
