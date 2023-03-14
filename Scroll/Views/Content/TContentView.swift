//
//  TContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct TContentView: View { // T[itle]ContentView to not conflict with ContentView
  private(set) var content: Content

  var body: some View {
    let title = content.title!

    // This doesn't appear centered for some reason.
    VStack {
      Text(title)
        .font(.title)
        .fontWeight(.medium)
    }
    #if os(macOS)
    .navigationTitle(title)
    #else
    .navigationSubtitle(title)
    #endif
    .toolbar {
      EditContentButtonView(id: content.id)

      // I'd like to use ToolbarItem with a placement of .destructiveAction, but, for some reason, the button won't
      // appear.
      DeleteContentButtonView(content: content)
    }
  }
}

struct TContentView_Previews: PreviewProvider {
  static private let viewContext = PersistenceController.preview.container.viewContext
  static private let content: Content = {
    let content = Content(context: viewContext)
    content.title = "Invasion"
    // Add some more stuff later.

    return content
  }()

  static var previews: some View {
    TContentView(content: content)
  }
}
