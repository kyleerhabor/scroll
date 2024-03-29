//
//  View.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/10/23.
//

import Foundation
import SwiftUI

extension View {
  func titleCoverStyle() -> some View {
    self.modifier(TitleCoverStyleModifier())
  }
}

struct TableLabeledContentStyle: LabeledContentStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
        .foregroundColor(.secondary)
      
      Spacer()
      configuration.content
    }
  }
}

extension LabeledContentStyle where Self == TableLabeledContentStyle {
  static var table: TableLabeledContentStyle { .init() }
}

enum FormPurpose {
  case create, edit
}

enum Navigation: Hashable, Codable {
  case titles, lists, title(Title), content(Content), entry(Entry)

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if let url = try? container.decode(URL.self),
       let object = CoreDataStack.getObject(from: url, with: CoreDataStack.shared.container.viewContext) {

      switch object {
        case let title as Title:
          self = .title(title)

          return
        case let content as Content:
          self = .content(content)

          return
        case let entry as Entry:
          self = .entry(entry)

          return
        default: // I don't know why I can't use @unknown here.
          break
      }
    }

    if let string = try? container.decode(String.self),
       string == "lists" {
      self = .lists

      return
    }

    self = .titles
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    switch self {
      case .titles: try container.encode("titles")
      case .lists: try container.encode("lists")
      case .title(let title): try container.encode(title.id)
      case .content(let content): try container.encode(content.id)
      case .entry(let entry): try container.encode(entry.id)
    }
  }
}
