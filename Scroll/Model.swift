//
//  Model.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/11/23.
//

import Foundation

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
