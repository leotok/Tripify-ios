//
//  Trip.swift
//  chp3
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
import CoreData

class Trip: NSManagedObject {

    @NSManaged var beginDate: NSDate
    @NSManaged var destination: String
    @NSManaged var endDate: NSDate
    @NSManaged var presentationImage: NSData
    @NSManaged var moments: NSSet
    var momentsArray: [Moment] = []

    class func entityName() -> String{
        
        return "Trip"
    }
    
    class func insertNewObjectIntoContext(context: NSManagedObjectContext) -> Trip {
        
        return NSEntityDescription.insertNewObjectForEntityForName( self.entityName(),
            inManagedObjectContext: context)
            as! Trip
    }
    
}
