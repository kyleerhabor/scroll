//
//  ModifiableImageView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/20/23.
//

import SwiftUI
import PhotosUI

struct ModifiableImageView<Label>: View where Label: View {
  @Binding var image: Data?
  @Binding var didError: Bool
  @ViewBuilder var label: () -> Label

  @State private var isHovering = false
  @State private var isPresentingPicker = false
  @State private var isPresentingFilePicker = false
  @State private var isPresentingPhotoPicker = false
  @State private var photos: [PhotosPickerItem] = []

  var body: some View {
    Button {
      isPresentingPicker = true
    } label: {
      // I experimented with adding a stroked border of smooth dashes signaling that the view supported upload
      // and thought it looked worse while making the view more complex for users. Simply changing opacity gives
      // enough detail.
      label()
      // 0.625 - x - 0.75
        .opacity(isHovering ? 0.6875 : 1)
        .onHover { isHovering = $0 }
        .popover(isPresented: $isPresentingPicker, arrowEdge: .trailing) {
          HStack {
            Button("Files") {
              isPresentingFilePicker = true
            }

            Button("Photos") {
              isPresentingPhotoPicker = true
            }

            Button(role: .destructive) {
              image = nil
            } label: {
              Image(systemName: "clear")
            }
          }.padding()
        }.fileImporter(isPresented: $isPresentingFilePicker, allowedContentTypes: [.image]) { result in
          guard case let .success(image) = result,
                let data = try? Data(contentsOf: image) else {
            didError = true

            return
          }

          self.image = data
        }.photosPicker(
          isPresented: $isPresentingPhotoPicker,
          selection: $photos,
          maxSelectionCount: 1,
          matching: .images
        ).onDrop(of: [.image], isTargeted: $isHovering) { providers in
          _ = providers.first?.loadDataRepresentation(for: .image) { data, err in
            // There better be a better way to do this.
            DispatchQueue.main.async {
              guard let data else {
                didError = true

                return
              }

              image = data
            }
          }

          return true
        }.animation(.default, value: isHovering)
    }
    .buttonStyle(.plain)
    .onChange(of: photos) { photos in
      photos.first!.loadTransferable(type: Data.self) { result in
        guard case let .success(cover) = result,
              let cover else {
          didError = true

          return
        }

        image = cover
      }
    }
  }
}

struct ModifiableImageView_Previews: PreviewProvider {
  @State private static var cover: Data?
  @State private static var didError = false

  static var previews: some View {
    ModifiableImageView(image: $cover, didError: $didError) {
      let width: CGFloat = 80

      TitleCoverView(cover: cover)
        .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
        .titleCoverStyle()
    }
    .focusable(false)
    .padding()
    .alert("Errored.", isPresented: $didError) {}
  }
}
