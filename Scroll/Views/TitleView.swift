//
//  TitleView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/5/23.
//

import SwiftUI

struct TitleView: View {
  private(set) var title: Title

  var body: some View {
    VStack {
      
    }
    .navigationTitle("Title")
    .navigationSubtitle(title.title!)
    .toolbar {
      Button {
        print("...")
      } label: {
        Label("Edit", systemImage: "pencil")
      }
    }
  }
}
