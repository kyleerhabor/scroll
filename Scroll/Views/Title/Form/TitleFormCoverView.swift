//
//  TitleFormCoverView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/20/23.
//

import SwiftUI

struct TitleFormCoverView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var title: Title

  @State private var didError = false
  @State private var isStale = false

  var body: some View {
    let width: CGFloat = 224 // 192 - 256

    VStack(spacing: 16) {
      ModifiableImageView(image: $title.cover, didError: $didError) {
        TitleCoverView(url: try? .init(resolvingBookmarkData: title.cover!, bookmarkDataIsStale: &isStale))
          .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
          .titleCoverStyle()
          .onChange(of: isStale) { stale in
            print(stale)
          }
      }.focusable(false)

      HStack {
        Text("Cover")
          .font(.headline)
          .fontWeight(.medium)

        FormControlView(purpose: .edit, complete: true) {
          guard case .success = viewContext.save() else {
            didError = true

            return
          }

          dismiss()
        } cancel: {
          viewContext.rollback()
          dismiss()
        }
      }
    }
    .padding()
    .alert("Could not save cover.", isPresented: $didError) {}
  }
}
