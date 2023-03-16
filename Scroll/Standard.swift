//
//  Standard.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/14/23.
//

import Foundation

func noop() {}

typealias SimpleAdditive = AdditiveArithmetic & ExpressibleByIntegerLiteral

func increment<T: SimpleAdditive>(_ number: T) -> T {
  number + 1
}

func decrement<T: SimpleAdditive>(_ number: T) -> T {
  number - 1
}

extension Duration {
  static let hour: Self = .seconds(3600)
}

extension URL {
  // Using URL(:string) requires an unwrap and sometimes fail when previewing (for some reason).
  static let nullDevice: Self = .init(filePath: "/dev/null")
}

// Source: https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/
extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
    return self.sorted { a, b in
      return a[keyPath: keyPath] < b[keyPath: keyPath]
    }
  }
}
