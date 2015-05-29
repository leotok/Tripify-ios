//
//  Moment.swift
//  triploka
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
import CoreData

class Moment: NSManagedObject {

    @NSManaged var category: NSNumber
    @NSManaged var comment: String
    @NSManaged var geoTag: AnyObject
    @NSManaged var index: NSNumber
    @NSManaged var photoAlbum: NSSet
    @NSManaged var trip: Trip

    class func entityName() -> String{
        
        return "Moment"
    }
    
    class func insertNewObjectIntoContext(context: NSManagedObjectContext) -> Moment {
        
        return NSEntityDescription.insertNewObjectForEntityForName( self.entityName(),
            inManagedObjectContext: context)
            as! Moment
    }
}
