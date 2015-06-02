//
//  LocalDAO.swift
//  triploka
//
//  Created by Victor Yves Crispim on 06/5/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import CoreData


class LocalDAO {
    
    static let sharedInstance = LocalDAO()
    
    
    private init(){
    }
    
    /*********************************************
    *
    *  MARK: - CoreData Stack
    *
    ***/
    
    lazy var applicationDocumentsDirectory: NSURL = {

        //  The directory the application uses to store the Core Data store file.
        //  This code uses a directory named "com.leowajnsztok.triploka" in the application's documents
        //  Application Support directory.
        
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory,
                                                                    inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {

        //  The managed object model for the application. This property is not optional.
        //  It is a fatal error for the application not to be able to find and load its model.
        
        let modelURL = NSBundle.mainBundle().URLForResource("triploka", withExtension: "momd")!
    
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        //  The persistent store coordinator for the application. This implementation creates and return a coordinator,
        //  having added the store for the application to it. This property is optional since there are legitimate error 
        //  conditions that could cause the creation of the store to fail. Create the coordinator and store
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("triploka.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
        
            coordinator = nil
            
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            //  Replace this with code to handle the error appropriately.
            //  abort() causes the application to generate a crash log and terminate.
            //  You should not use this function in a shipping application, although it may be useful during development.
            
            println("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        //  Returns the managed object context for the application (which is already bound to the persistent store coordinator
        //  for the application.) This property is optional since there are legitimate error conditions that could cause 
        //  the creation of the context to fail.
        
        let coordinator = self.persistentStoreCoordinator

        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()

    
    /*********************************************
    *
    *  MARK:    CoreData Saving support
    *
    ***/
    
    func saveContext () {

        if let moc = self.managedObjectContext {
        
            var error: NSError? = nil
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
          
                if moc.hasChanges && !moc.save(&error) {
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    println("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    
    /*********************************************
    *
    *  MARK:    CoreData Loading support
    *
    ***/
    
    func loadObjectGraph(){

        let tripRequest = NSFetchRequest(entityName: "Trip")
        let momentRequest = NSFetchRequest(entityName: "Moment")
        
        var error : NSError?

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let teste = self.managedObjectContext?.executeFetchRequest(tripRequest, error: &error) as! [Photo]
            
            if error != nil{
                println("Erro no fetch inicial: viagens não carregadas")
            }
            
            self.managedObjectContext?.executeFetchRequest(momentRequest, error: &error)

            if error != nil{
                println("Erro no fetch inicial: momentos não carregados")
            }
            
            println("Fetch inicial concluido com sucesso")
        }
    }
    
    
    /*********************************************
    *
    *  MARK:    Instance Methods
    *
    ***/
    
    /**
     *
     *  Gets all the Trips stored on the CoreData Sersistent Store
     *
     *  :returns: An array of Trip objects
     *
    */
    func getAllTrips() -> [Trip]{
        
        let tripRequest = NSFetchRequest(entityName: "Trip")
        
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(tripRequest, error: &error)
        
        if error != nil{
            println("Erro: viagens não carregadas. \(error)")
        }
        
        return tripsArray as! [Trip]
    }
    
    /**
    *
    *  Gets the total number of different countries visited so far
    *
    */
    func getNumberOfVisitedCountries() -> Int{
        
        let request = NSFetchRequest(entityName: "Trip")
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error) as! [Trip]
        
        
        var destinations = NSMutableSet()
        
        for trip in tripsArray{
            
            if !trip.destination.isEmpty{
                
                destinations.addObject(trip.destination)
            }
        }
        
        return destinations.count
    }

    /**
    *
    *  Gets the total number of new friends met so far
    *
    */
    func getNumberOfNewFriends() -> Int{
        
        let request = NSFetchRequest(entityName: "Moments")
        request.predicate = NSPredicate(format: "(category == %@)", MomentCategory.MetSomeone.rawValue)
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error)
        
        return tripsArray!.count
    }

    /**
    *
    *  Gets the total number of restaurants visited so far
    *
    */
    func getNumberOfRestaurants() -> Int{

        let request = NSFetchRequest(entityName: "Moments")
        request.predicate = NSPredicate(format: "(category == %@)", MomentCategory.Restaurant.rawValue)
        var error : NSError?
        
        let tripsArray = self.managedObjectContext?.executeFetchRequest(request, error: &error)
        
        return tripsArray!.count
    }
}