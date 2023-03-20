//
//  EditContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import SwiftUI

struct EditContentFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var id: Content.ID
  @State private var title = ""
  @State private var kind: Content.Kind?
  @State private var hours = 0
  @State private var minutes = 0
  @State private var seconds = 0
  @State private var pages = 0
  @State private var didError = false

  var body: some View {
    ContentFormView(
      purpose: .edit,
      title: $title,
      kind: $kind,
      hours: $hours,
      minutes: $minutes,
      seconds: $seconds,
      pages: $pages,
      submit: submit
    ) {
      viewContext.rollback()
      dismiss()
    }
    .alert("Could not edit content.", isPresented: $didError) {}
    .onAppear {
      let content = getContent()

      title = content.title!
      kind = content.kind

      if let episode = content.episode {
        // This sucks.
        hours = Int(episode.duration / 60 / 60)
        minutes = Int(episode.duration / 60 % 60)
        seconds = Int(episode.duration % 60)
      }

      if let chapter = content.chapter {
        pages = Int(chapter.pages)
      }
    }
  }

  func getContent() -> Content {
    CoreDataStack.getObject(from: id, with: viewContext) as! Content
  }

  func submit() {
    let content = getContent()
    content.title = title
    content.kind = kind

    let episode = content.episode ?? createEpisode(for: content)
    episode.duration = Int32((hours * 60 * 60) + (minutes * 60) + seconds)

    let chapter = content.chapter ?? createChapter(for: content)
    chapter.pages = Int16(pages)

    do {
      try viewContext.save()

      dismiss()
    } catch let err {
      print(err)

      didError = true
    }
  }

  func createEpisode(for content: Content) -> Episode {
    let episode = Episode(context: viewContext)
    episode.content = content

    return episode
  }

  func createChapter(for content: Content) -> Chapter {
    let chapter = Chapter(context: viewContext)
    chapter.content = content

    return chapter
  }
}

struct EditContentFormView_Previews: PreviewProvider {
  static var previews: some View {
    EditContentFormView(id: .nullDevice)
  }
}
