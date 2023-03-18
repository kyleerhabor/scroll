//
//  EntryFormChapterView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/18/23.
//

import SwiftUI

struct EntryFormChapterView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var entry: Entry

  @SceneStorage("pages") private var pages: Double = 0
  private let formatter = NumberFormatter.integer

  var body: some View {
    Group {
      let pages = Double(entry.content!.chapter!.pages)
      let progress = self.pages.clamp(from: 0, to: pages)

      // I experimented with Gauge and it doesn't look good.
      ProgressView(value: progress, total: pages) {
        // Empty
      } currentValueLabel: {
        let percent = (progress / pages).formatted(.percent.precision(.significantDigits(1...2)))

        Text("\(Int(progress)) of \(Int(pages)) pages (\(percent))")
      }

      TextField("Pages", value: $pages, formatter: formatter)
    }.onAppear {
      if let chapter = entry.chapter {
        pages = Double(chapter.progress)
      }
    }.onChange(of: pages) { pages in
      let chapter = chapter()
      chapter.progress = .init(pages.clamp(from: 0, to: Double(Int32.max)))
    }
  }

  func createChapter() -> EntryChapter {
    let chapter = EntryChapter(context: viewContext)
    chapter.entry = entry

    return chapter
  }

  func chapter() -> EntryChapter {
    entry.chapter ?? createChapter()
  }
}

struct EntryFormChapterView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  // Kino's Journey (light novel), volume 1, chapter 1, "Prologue: In the Forest・b -Lost in the Forest・b-"
  static private let entry: Entry = {
    let entry = Entry(context: context)
    let content = Content(context: context)
    content.addToEntries(entry)

    let chapter = Chapter(context: context)
    chapter.content = content
    chapter.pages = 2

    let eChapter = EntryChapter(context: context)
    eChapter.progress = 1
    eChapter.entry = entry

    return entry
  }()

  static var previews: some View {
    Form {
      EntryFormChapterView(entry: entry)
    }.formStyle(.grouped)
  }
}
