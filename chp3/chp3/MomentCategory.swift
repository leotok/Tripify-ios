//
//  MomentCategory.swift
//  chp3
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation


/**

    This enum defines the possible
    categories of a Moment, and consequently
    defines the information to be displayed at
    the world map and user's passport.

    It's defined as Int32 so it can be stored
    in CoreData
*/

enum MomentCategory : Int32{
    
    case MetSomeone = 0
    case Restaurant
    case Hotel
    case Party
    case NewPlace
    case Other
}
