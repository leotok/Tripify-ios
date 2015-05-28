//
//  CoreDataTestViewController.swift
//  chp3
//
//  Created by Victor Yves Crispim on 05/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit
import CoreData


class CoreDataTestViewController: UIViewController, ManagedObjectContextHandler {
    
    
    //MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    private var context : NSManagedObjectContext?
    
    
    init(context: NSManagedObjectContext?){
        
        super.init(nibName: "CoreDataTest", bundle: nil)
        self.context = context
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        //CoreData test
        var newTrip = Trip.insertNewObjectIntoContext(context!)
        newTrip.destination = "Rome"
        newTrip.beginDate = NSDate()
        newTrip.endDate = NSDate(timeInterval: 2419200, sinceDate: newTrip.beginDate)
        newTrip.presentationImage = NSData(data: UIImageJPEGRepresentation(UIImage(named: "teste.jpg"), 1))
        
        var error : NSError? = nil
        
        if !self.context!.save(&error){
            println("Problem saving the object. Error: \(error), \(error!.localizedDescription)")
        }
        
        
        
        
        /*
        *   Search for the atributes that were set on the app delegate.
        *   Instead of propertiesToFetch:, you could use the predicate
        *   property of NSFetchRequest
        */
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        //        let entity = NSEntityDescription.entityForName("Trip", inManagedObjectContext: self.context!)
        //        fetchRequest.entity = entity
        //        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        //        fetchRequest.returnsDistinctResults = true
        //        fetchRequest.propertiesToFetch = ["destination", "presentationImage"]
        //
        //        let allProperties = entity?.propertiesByName as! [String : NSPropertyDescription]
        //
        //        fetchRequest.propertiesToFetch =    [   allProperties["destination"]!,
        //                                                allProperties["presentationImage"]!
        //                                            ]
        
        var error2 : NSError? = nil
        let retrievedObjects = self.context?.executeFetchRequest(fetchRequest, error: &error2)
        
        
        
        if let results = retrievedObjects as? [Trip]{
            
            if results.count > 0 {
                let match = results[0]
                var b = match.destination
                var a = UIImage(data: match.presentationImage)
                imageView.image = UIImage(data: match.presentationImage)
                
            }
            else{
                println("Empty Response")
            }
        }
    }
    
    /*********************************************
    *
    *  MARK:
    *
    ***/
    
    func setManagedObjectContext(context: NSManagedObjectContext) {
        
        if let contx = self.context{
            println("This view controller is already managing a NSManagedObjectContext\n")
        }
        else{
            self.context = context
        }
    }
    
}
