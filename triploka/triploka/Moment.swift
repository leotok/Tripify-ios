//
//  Moment.swift
//  triploka
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import CoreLocation
import CoreData


/**
 *
 *   Classe do modelo, representando o momento
 *   de uma viagem. É responsável por controlar
 *   sua relação com o PersistentStore do CoreData
 *
*/
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
    
    /**
     *
     *  Getter method to the geoTag property
     *
     *  :returns: a CLLocation object
     *
    */
    func getGeoTag() -> CLLocation{
        
        return self.geoTag as! CLLocation
    }
    
    
    /**
     *
     *  Setter method to the geoTag property
     *
     *  :param: newGeoTag: the new CLLocation object to be
     *  attributed
     *
    */
    func changeGeoTag(newGeoTag: CLLocation){
        
        self.geoTag = newGeoTag
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    /**
     *
     *  Gets all the photos associated with this moment
     *
     *  :returns: an array of UIImages
     *
    */
    func getAllPhotos() -> [UIImage]{
        
        let photoAlbum = self.mutableSetValueForKey("photoAlbum")
        var allPhotos = photoAlbum.mutableSetValueForKey("image")
        return allPhotos.allObjects as! [UIImage]
    }

    /**
     *
     *  Adds a new photo to the moment
     *
     *  :param: photo: The new image to be added
     *
    */
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