//
//  TitleCoverView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/9/23.
//

import SwiftUI

struct TitleCoverView: View {
  private(set) var cover: Data?

  var body: some View {
    Group {
      if let data = cover,
         let image = NSImage(data: data) {
        Image(nsImage: image)
          .resizable()
          .scaledToFill()
      } else {
        Color.secondary
      }
    }.cornerRadius(4) // Maybe 6 or 8?
  }
}
