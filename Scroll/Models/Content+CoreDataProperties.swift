//
//  Content+CoreDataProperties.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/25/23.
//
//

import Foundation
import CoreData


extension Content {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var type: Int16
    @NSManaged public var chapter: Chapter?
    @NSManaged public var entries: Set<Entry>?
    @NSManaged public var episode: Episode?
    @NSManaged public var titleRef: Title?

}

// MARK: Generated accessors for entries
extension Content {
    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Content : Identifiable {}
