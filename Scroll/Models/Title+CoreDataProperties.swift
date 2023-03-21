//
//  Title+CoreDataProperties.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/16/23.
//
//

import Foundation
import CoreData

extension Title {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
    return NSFetchRequest<Title>(entityName: "Title")
  }

  @NSManaged public var cover: Data?
  @NSManaged public var desc: String?
  @NSManaged public var title: String?
  @NSManaged public var qualifier: String?
  @NSManaged public var contents: Set<Content>? // ...
}

// MARK: Generated accessors for contents
extension Title {
  @objc(addContentsObject:)
  @NSManaged public func addToContents(_ value: Content)

  @objc(removeContentsObject:)
  @NSManaged public func removeFromContents(_ value: Content)

  @objc(addContents:)
  @NSManaged public func addToContents(_ values: NSSet)

  @objc(removeContents:)
  @NSManaged public func removeFromContents(_ values: NSSet)
}

extension Title: Identifiable {
  public var id: URL {
    self.objectID.uriRepresentation()
  }
}
