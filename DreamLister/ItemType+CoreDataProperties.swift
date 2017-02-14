//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Павел Мартыненков on 15.11.16.
//  Copyright © 2016 Pavel Martynenkov. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
