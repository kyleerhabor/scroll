//
//  EntryFormEpisodeView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/17/23.
//

import SwiftUI

struct EntryFormEpisodeView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @ObservedObject var entry: Entry

  // For some reason, I need the initial values.
  @SceneStorage("hours") private var hours: Double = 0
  @SceneStorage("minutes") private var minutes: Double = 0
  @SceneStorage("seconds") private var seconds: Double = 0
  private let formatter = NumberFormatter.integer

  var body: some View {
    Group {
      let duration = Double(entry.content!.episode!.duration)
      let progress = Double(
        DateComponents(
          hour: Int(hours),
          minute: Int(minutes),
          second: Int(seconds)
        ).seconds()
      ).clamp(from: 0, to: duration)

      ProgressView(value: progress, total: duration) {
        // Empty
      } currentValueLabel: {
        // For episodes that span less than an hour, it looks verbose to have the hour component just be zeroes on both
        // the progress and duration. This is especially so for titles which span less than an hour for each episode
        // (e.g. TV). If a title has a mix of short (< hour) and long (> hour) episodes, then I could imagine justifying
        // the zeroes, but a TV itself doesn't know its format (it could be a mix of e.g. episodes and chapters).
        let format = Duration.TimeFormatStyle.time(pattern: Duration.seconds(duration).pattern())

        let point = Duration.seconds(progress).formatted(format)
        let length = Duration.seconds(duration).formatted(format)
        let percent = (progress / duration).formatted(.percent.precision(.significantDigits(1...2)).rounded(rule: .down))

        Text("\(point) / \(length) (\(percent))")
      }

      TextField("Hours", value: $hours, formatter: formatter)
        .onChange(of: seconds) { _ in updateEpisodeProgress() }

      TextField("Minutes", value: $minutes, formatter: formatter)
        .onChange(of: minutes) { _ in updateEpisodeProgress() }

      TextField("Seconds", value: $seconds, formatter: formatter)
        .onChange(of: hours) { _ in updateEpisodeProgress() }
    }.onAppear {
      if let progress = entry.episode?.progress {
        hours = Double(progress / 60 / 60)
        minutes = Double(progress / 60 % 60)
        seconds = Double(progress % 60)
      }
    }
  }

  func createEpisode() -> EntryEpisode {
    let episode = EntryEpisode(context: viewContext)
    episode.entry = entry

    return episode
  }

  func updateEpisodeProgress() {
    let episode = entry.episode ?? createEpisode()
    let progress = DateComponents(hour: Int(hours), minute: Int(minutes), second: Int(seconds))
      .seconds()
      .clamp(from: 0, to: Int(Int32.max))

    episode.progress = Int32(progress)
  }
}

struct EntryFormEpisodeView_Previews: PreviewProvider {
  static private let context = CoreDataStack.preview.container.viewContext
  static private let entry: Entry = {
    let entry = Entry(context: context)
    let content = Content(context: context)
    content.title = "The Battle of Gosroth"

    content.addToEntries(entry)

    let cEpisode = Episode(context: context)
    cEpisode.content = content
    cEpisode.duration = Int32(DateComponents(minute: 25, second: 5).seconds())

    let eEpisode = EntryEpisode(context: context)
    eEpisode.progress = Int32(DateComponents(minute: 2, second: 46).seconds())

    entry.episode = eEpisode

    return entry
  }()

  static var previews: some View {
    Form {
      EntryFormEpisodeView(entry: entry)
    }.formStyle(.grouped)
  }
}
