//
//  Model.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/11/23.
//

import Foundation

// Since Models contains Core Data generated files, I'd prefer to separate manual generation out of necessity (e.g.
// changing NSSet to Set<Element>) and extensions for makings things simpler to use.
//
// Interestingly, modifying Identifiable conformance in CoreDataProperties results in a crash.

extension Title {
  public var id: URL {
    self.objectID.uriRepresentation()
  }

  var name: String? {
    guard let title = self.title else {
      return nil
    }

    guard let qualifier = self.qualifier else {
      return title
    }

    return "\(title) (\(qualifier))"
  }
}

extension Content {
  public var id: URL {
    self.objectID.uriRepresentation()
  }

  enum Kind: Int16 {
    case episode, chapter
  }

  var kind: Kind? {
    // I don't like how the order matters (e.g. if I remove a case it'll affect the rest).
    get {
      if self.type == 0 {
        return nil
      }

      return Kind(rawValue: decrement(self.type))
    }
    set {
      if let newValue {
        self.type = increment(newValue.rawValue)
      } else {
        self.type = 0
      }
    }
  }
}
