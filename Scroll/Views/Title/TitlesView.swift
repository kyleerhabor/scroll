//
//  TitlesView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/25/23.
//

import SwiftUI

struct TitlesView: View {
  @FetchRequest(
    sortDescriptors: [.init(\.title), .init(\.qualifier)],
    animation: .default
  )
  private var titles: FetchedResults<Title>

  var body: some View {
    // A List would probably look better on smaller orientations.
    let width: CGFloat = 128

    LazyVGrid(columns: [.init(.adaptive(minimum: width))]) {
      ForEach(titles) { title in
        NavigationLink(value: Navigation.title(title)) {
          // For some reason, the blue outline (highlight) is sometimes wider than the view by a variable amount.
          //
          // The default spacing is a bit much; 4 is too much, and 2 is a bit too short. 3 looks "fine".
          VStack(alignment: .leading, spacing: 3) {
            var isStale = false

            TitleCoverView(url: try? .init(resolvingBookmarkData: title.cover!, bookmarkDataIsStale: &isStale))
              .frame(width: width, height: TitleCoverStyleModifier.height(from: width))
              .titleCoverStyle()

            let name = title.title!
            let qualifier = title.qualifier

            // The line limit with reserved spacing is enforced to align the titles (specifically the cover images)
            // vertically. A limit of 1 is compact and too short for many titles; a limit of 3 is too spacious and
            // still suseptible to longer titles; a limit of 2 catches many titles while missing some (e.g. "Made in
            // Abyss: The Golden City of the Scorching Sun"), but is "just right" for how much space it occupies.
            Group {
              if let qualifier {
                Text("\(name) \(Text(qualifier).foregroundColor(.secondary))")
              } else {
                Text(name)
              }
            }
            .font(.callout)
            .bold()
            .lineLimit(2, reservesSpace: true)
            .help(title.name!)
          }
        }
        .frame(width: width)
        .buttonStyle(.plain)
        .contextMenu {
          EditTitleButtonView(id: title.id)

          if let contents = title.contents, !contents.isEmpty {
            CreateListPlanButtonView(contents: contents.map(\.id))
          }
        }
      }
    }
  }
}

struct TitlesView_Previews: PreviewProvider {
  static var previews: some View {
    TitlesView()
  }
}
