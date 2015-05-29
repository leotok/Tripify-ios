//
//  GenericViewController.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 25/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

import CoreData
import CoreLocation

class GenericViewController: UIViewController,SWRevealViewControllerDelegate {

    var sideMenuButton = UIBarButtonItem()
    var color :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let revealController :SWRevealViewController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        
        sideMenuButton.tintColor = UIColor.whiteColor()
        sideMenuButton.image = UIImage(named: "Menu-25")
    
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
            
        }
        
        self.test()
    
    }
    
    
    func test(){

//        var testMoment = Moment()
//        
//        testMoment.changeGeoTag(CLLocation(latitude: 2423423, longitude: 234234234))
//        testMoment.addNewPhoto(UIImage(named: "teste")!)
//        testMoment.addNewPhoto(UIImage(named: "maria")!)
//        testMoment.addNewPhoto(UIImage(named: "arc")!)
        
        
        var appDelegate : AppDelegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context = appDelegate.managedObjectContext
        
        
        var request : NSFetchRequest
        request = NSFetchRequest(entityName: "Moment")
        
        var erro : NSError?
        var result : [Moment]
        
        result = context!.executeFetchRequest(request, error: &erro)! as! [Moment]
        println(result.count)
        
        var allImages : [UIImage]?
        
        for moment in result{
            
            allImages = moment.getAllPhotos()
            println(allImages!.count)
        }
    }
}
