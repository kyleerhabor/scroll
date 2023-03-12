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
}
