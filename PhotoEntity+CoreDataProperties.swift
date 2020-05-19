//
//  PhotoEntity+CoreDataProperties.swift
//  EnternProject
//
//  Created by Мухтарпаша on 18.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//
//

import Foundation
import CoreData

// Свойства к нашему классу
extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var desc: String?
    @NSManaged public var url: String?

}
