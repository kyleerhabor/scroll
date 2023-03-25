//
//  EntryView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/25/23.
//

import SwiftUI

struct EntryView: View {
  @ObservedObject var entry: Entry

  var body: some View {
    Text("Hello, World!")
  }
}

struct EntryView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let entry: Entry = {
    let entry = Entry(context: context)

    return entry
  }()

  static var previews: some View {
    EntryView(entry: entry)
  }
}
