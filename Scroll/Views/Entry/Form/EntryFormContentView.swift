//
//  EntryFormContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/15/23.
//

import SwiftUI

struct EntryFormContentView: View {
  private(set) var content: Content
  @State private var progress: Double = 30

  var body: some View {
    if let kind = content.kind {
      switch kind {
        case .episode:
          if let duration = content.episode?.duration {
            // For episodes that span less than an hour, it looks verbose to have the hour component just be zeroes on
            // both the progress and duration. This is especially so for titles which span ~24 minutes for each episode
            // (i.e. TV). If a title has a mix of short (< hour) and long (> hour) episodes, then I could imagine
            // justifying the zeroes, but a TV itself doesn't know its format (it could be a mix of e.g. episodes and
            //chapters)
            let format = Duration.TimeFormatStyle.time(
              pattern: Duration.seconds(duration) >= .hour
                ? .hourMinuteSecond
                : .minuteSecond
            )

            EntryFormProgressView(progress: progress, total: Double(duration)) {
              Text("\(Duration.seconds(progress).formatted(format)) / \(Duration.seconds(duration).formatted(format))")
            }
          }
        case .chapter:
          if let pages = content.chapter?.pages {
            EntryFormProgressView(progress: progress, total: Double(pages)) {
              Text("\(Int(progress)) of \(pages) pages.")
            }
          }
      }
    }
  }
}

//struct EntryFormContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    EntryFormContentView()
//  }
//}
