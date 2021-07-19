//
//  Tasks+CoreDataProperties.swift
//  CoreDataToDoApp
//
//  Created by IwasakIYuta on 2021/07/19.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var task: String?
    @NSManaged public var date: Date?
    @NSManaged public var memo: String?

}

extension Tasks : Identifiable {

}
