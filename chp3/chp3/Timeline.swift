//
//  Timeline.swift
//  chp3
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
import CoreData

class Timeline: NSManagedObject {

    @NSManaged var trip: Trip
    @NSManaged var moments: [Moment]


}
