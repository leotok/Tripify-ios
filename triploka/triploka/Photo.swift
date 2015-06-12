//
//  MomentAlbum.swift
//  triploka
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
import CoreData

@objc
class Photo: NSManagedObject {

    /*********************************************
    *
    *  MARK: Properties
    *
    ***/
    
    @NSManaged private var image: AnyObject
    @NSManaged var moment: NSManagedObject
    
    
    
    /*********************************************
    *
    *  MARK: Initializer
    *
    ***/
    
    convenience init() {
        
        var context : NSManagedObjectContext
        context = LocalDAO.sharedInstance.managedObjectContext!
        
        var entity : NSEntityDescription
        entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext:context)
    }
    
    
    
    /*********************************************
    *
    *  MARK: Instance Methods
    *
    ***/
    
    func getImage() -> UIImage{
        return self.image as! UIImage
    }
    
    func setNewImage(newImage: UIImage){
        
        self.image = newImage
        //LocalDAO.sharedInstance.saveContext()
    }
}