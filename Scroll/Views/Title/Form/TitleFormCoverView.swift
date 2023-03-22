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

  @State private var cover: Data?
  @State private var didError = false

  var body: some View {
    let width: CGFloat = 224 // 192 - 256

    VStack(spacing: 16) {
      ModifiableImageView(image: $cover, didError: $didError) {
        TitleCoverView(cover: cover)
          .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
          .titleCoverStyle()
      }.focusable(false)

      HStack {
        Text("Cover")
          .font(.headline)
          .fontWeight(.medium)

        FormControlView(purpose: .edit, complete: true) {
          title.cover = cover

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
    .onAppear {
      cover = title.cover
    }
  }
}

//struct TitleFormCoverView_Previews: PreviewProvider {
//  static var previews: some View {
//    TitleFormCoverView(title: <#Title#>, cover: <#Binding<Data?>#>)
//  }
//}
