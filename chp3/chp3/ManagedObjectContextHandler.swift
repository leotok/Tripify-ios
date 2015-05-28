//
//  ManagedObjectContextHandler.swift
//  chp3
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import CoreData

/**
    This interface should be implemented by any 
    UIViewController responsible for manipulating 
    CoreData objects
*/

protocol ManagedObjectContextHandler {
    
    func setManagedObjectContext(context : NSManagedObjectContext)
}
