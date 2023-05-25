//
//  TitleCoverView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/9/23.
//

import SwiftUI

struct TitleCoverView: View {
  // Images are primarily saved as Data for Core Data, but it's problematic since there's no clear way to get a URL to
  // that image: only its binary data format, which isn't good to be loading on the main thread as an image. I think
  // I'll need to save the image separately while holding a URL (as a bookmark) so it can be fed into AsyncImage.
  var url: URL?

  var body: some View {
//    AsyncImage(url: url) { phase in
//      switch phase {
//        case .success(let image):
//          image
//            .resizable()
//            .scaledToFill()
//        case .failure(let err):
//          Color.red
//            .onAppear { print(err) }
//        default:
//          Color(.clear)
//            .background(.tertiary)
//      }
//    }
    AsyncImage(url: url) { image in
      image
        .resizable()
        .scaledToFill()
    } placeholder: {
      Color(.clear)
        .background(.tertiary)
    }
  }
}

struct TitleCoverView_Previews: PreviewProvider {
  static var previews: some View {
    TitleCoverView()
  }
}
