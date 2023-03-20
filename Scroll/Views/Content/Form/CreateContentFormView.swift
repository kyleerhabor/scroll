//
//  CreateContentFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/12/23.
//

import SwiftUI

struct CreateContentFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  private(set) var titleId: Title.ID
  @State private var name = ""
  @State private var kind: Content.Kind?
  @State private var hours = 0
  @State private var minutes = 0
  @State private var seconds = 0
  @State private var pages = 0
  @State private var didError = false

  var body: some View {
    ContentFormView(
      purpose: .create,
      title: $name,
      kind: $kind,
      hours: $hours,
      minutes: $minutes,
      seconds: $seconds,
      pages: $pages,
      submit: submit,
      cancel: dismiss.callAsFunction
    ).alert("Could not create content.", isPresented: $didError) {}
  }

  func submit() {
    let content = Content(context: viewContext)
    content.titleRef = (CoreDataStack.getObject(from: titleId, with: viewContext) as! Title)
    content.title = name
    content.kind = kind

    let episode = Episode(context: viewContext)
    episode.content = content
    episode.duration = Int32((hours * 60 * 60) + (minutes * 60) + seconds)

    content.episode = episode

    let chapter = Chapter(context: viewContext)
    chapter.content = content
    chapter.pages = Int16(pages)

    content.chapter = chapter

    guard case .success = viewContext.save() else {
      didError = true

      return
    }

    dismiss()
  }
}

struct CreateContentFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateContentFormView(titleId: .nullDevice)
  }
}
