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

  func pattern() -> Self.TimeFormatStyle.Pattern {
    return self >= .hour ? .hourMinuteSecond : .minuteSecond
  }
}

extension URL {
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

// Maybe a better name?
typealias SideEffect = () -> Void

extension DateComponents {
  func seconds() -> Int {
    let hour = self.hour ?? 0
    let chour = hour.clampMulti(60 * 60)
    let minute = self.minute ?? 0
    let cminute = minute.clampMulti(60)
    let second = self.second ?? 0

    return chour.clampAdd(cminute).clampAdd(second)
  }
}

extension Comparable {
  func clamp(from lower: Self, to upper: Self) -> Self {
    min(upper, max(lower, self))
  }
}

extension NumberFormatter {
  static var integer: Self {
    let formatter = Self()
    formatter.allowsFloats = false

    return formatter
  }
}

extension FixedWidthInteger {
  func clampAdd(_ x: Self) -> Self {
    let result = self.addingReportingOverflow(x)

    if result.overflow {
      // I don't think this is the best way to check what the clamped value would've been.
      switch result.partialValue.signum() {
        case 1: return Self.min
        case -1: return Self.max
        default: return 0 // This is not reachable. Maybe replace the value with an enum?
      }
    }

    return result.partialValue
  }

  func clampMulti(_ x: Self) -> Self {
    let result = self.multipliedReportingOverflow(by: x)

    if result.overflow {
      if self.signum() == x.signum() {
        return Self.max
      }

      return Self.min
    }

    return result.partialValue
  }
}
