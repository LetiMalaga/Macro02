//
//  Activity+CoreDataProperties.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 11/11/24.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var descriptionText: String
    @NSManaged public var id: UUID
    @NSManaged public var tag: String
    @NSManaged public var type: String
    @NSManaged public var isCSV: Bool

}

extension Activity : Identifiable {

}
