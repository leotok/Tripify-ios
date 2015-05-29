//
//  Moment.swift
//  triploka
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import CoreLocation
import CoreData

class Moment: NSManagedObject {

    /*********************************************
    *
    *  MARK: Properties
    *
    ***/
    
    @NSManaged var index: NSNumber
    @NSManaged var category: NSNumber
    @NSManaged var comment: String
    @NSManaged private var geoTag: AnyObject
    @NSManaged private var photoAlbum: NSSet
    @NSManaged var trip: Trip

    /**
    *
    *   Convenience init, so you don't have to pass an entity
    *   and the ManagedObjectContext as parameters
    *
    *   :returns: a new instance of a Moment
    *
    */
    convenience init() {
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context : NSManagedObjectContext
        context = appDelegate.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
    }
    
    
    //    class func entityName() -> String{
    //
    //        return "Moment"
    //    }
    //
    //    class func insertNewObjectIntoContext(context: NSManagedObjectContext) -> Moment {
    //
    //        return NSEntityDescription.insertNewObjectForEntityForName( self.entityName(),
    //            inManagedObjectContext: context)
    //            as! Moment
    //    }
    
    func getGeoTag() -> CLLocation{
        
        return self.geoTag as! CLLocation
    }
    
    func changeGeoTag(newGeoTag: CLLocation){
        
        self.geoTag = newGeoTag
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    
    func getAllPhotos() -> [UIImage]{
        
        let photoAlbum = self.mutableSetValueForKey("photoAlbum")
        var allPhotos = photoAlbum.mutableSetValueForKey("image")
        return allPhotos.allObjects as! [UIImage]
    }

    func addNewPhoto(photo: UIImage){
        
        let photoAlbum = self.mutableSetValueForKey("photoAlbum")
        
        var newPhoto = Photo()
        newPhoto.setNewImage(photo)
        newPhoto.moment = self
        
        photoAlbum.addObject(newPhoto)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
}