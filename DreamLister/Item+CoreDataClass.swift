//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Павел Мартыненков on 15.11.16.
//  Copyright © 2016 Pavel Martynenkov. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
