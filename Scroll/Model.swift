//
//  Model.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/11/23.
//

import Foundation

extension Title {
  public var id: URL {
    self.objectID.uriRepresentation()
  }

  // I *really* do not like this. There has to be a better way to do this (especially for CoreData sorting).
  var contentsArray: [Content] {
    guard let cont = self.contents else {
      return []
    }

    return cont.allObjects as! [Content]
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

      return Kind(rawValue: self.type - 1)
    }
    set {
      if let newValue {
        self.type = newValue.rawValue + 1
      } else {
        self.type = 0
      }
    }
  }
}

