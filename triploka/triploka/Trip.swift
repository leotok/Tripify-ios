//
//  Trip.swift
//  triploka
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
import CoreData

class Trip: NSManagedObject {
    
    /*********************************************
    *
    *  MARK: Properties
    *
    ***/
    
    
    @NSManaged var beginDate: NSDate
    @NSManaged var endDate: NSDate
    @NSManaged var destination: String
    @NSManaged var presentationImage: AnyObject
    @NSManaged var moments: NSSet
    
    /**
    *
    *   Convenience init, so you don't have to pass an entity
    *   and the ManagedObjectContext
    *
    *   :returns: a new instance of a Trip
    *
    */
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
        
    }
    
    
    /*********************************************
    *
    *  MARK: Instance Methods
    *
    ***/
    
    
    func getPresentationImage() -> UIImage{
        
        return self.presentationImage as! UIImage
    }
    
    func changePresentationImage(newImage: UIImage){
        
        self.presentationImage = newImage
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    
    /**
    *
    *  Gets all the moments in a Trip
    *
    *  :returns: A Moment array, sorted by their index
    *
    */
    func getAllMoments() -> [Moment]{
        
        let moments = self.mutableSetValueForKey("moments")
        
        var sortDescriptors = [NSSortDescriptor]()
        sortDescriptors.append(NSSortDescriptor(key: "index", ascending: true))
        
        var momentsArray = moments.sortedArrayUsingDescriptors(sortDescriptors)
        return momentsArray as! [Moment]
    }
    
    /**
    *
    *  Adds a new moment to a Trip, updating its index
    *
    *  :param: moment The Moment object to be inserted
    *
    */
    func addNewMoment(moment: Moment){
        
        var allMoments = self.mutableSetValueForKey("moments")
        var nextIndex = allMoments.count + 1
        moment.index = nextIndex
        
        allMoments.addObject(moment)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    /**
    *
    *  Gets an specific moment of a Trip
    *
    *  :param: index: The index that identifies the moment
    *
    *  :returns: The correct moment, or nil if the index is
    *            out of bounds
    *
    */
    func getMomentWithIndex(index: Int) -> Moment?{
        
        let allMoments = self.mutableSetValueForKey("moments")
        
        if index < 0 || index >= allMoments.count{
            
            println("Couldn't get moment. Invalid index")
            return nil
        }
        
        allMoments.filterUsingPredicate(NSPredicate(format: "(index == %@)", index))
        
        if allMoments.count == 1{
            return allMoments.anyObject() as! Moment?
        }
        else{
            println("Could not retrieve moment with index \(index)")
            return nil
        }
    }
}
