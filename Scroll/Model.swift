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
}
