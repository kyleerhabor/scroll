//
//  Standard.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import Foundation

func noop() {}

extension URL {
  static var nullDevice: Self {
    .init(string: "/dev/null")!
  }
}
