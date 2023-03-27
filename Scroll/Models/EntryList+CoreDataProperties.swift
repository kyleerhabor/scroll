//
//  EntryList+CoreDataProperties.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/26/23.
//
//

import Foundation
import CoreData

extension EntryList {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<EntryList> {
    return NSFetchRequest<EntryList>(entityName: "EntryList")
  }

  @NSManaged public var notes: String?
  @NSManaged public var entries: Set<Entry>?

}

// MARK: Generated accessors for entries
extension EntryList {
  @objc(addEntriesObject:)
  @NSManaged public func addToEntries(_ value: Entry)

  @objc(removeEntriesObject:)
  @NSManaged public func removeFromEntries(_ value: Entry)

  @objc(addEntries:)
  @NSManaged public func addToEntries(_ values: Set<Entry>)

  @objc(removeEntries:)
  @NSManaged public func removeFromEntries(_ values: Set<Entry>)
}
