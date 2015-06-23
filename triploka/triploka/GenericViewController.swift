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
    var statistic1: UILabel!
    var statistic2: UILabel!
    var statistic3: UILabel!

    
    override func viewDidLoad() {

        super.viewDidLoad()
    
        setupBackground()
        setupProfile()
        setupUserStats()
        setupNavigationController()
        
        //self.test()
        
    }
    
    private func applyBlurEffect(image: UIImage) -> UIImage{
        
        var imageToBlur = CIImage(image: image)
        var blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        var resultImage = blurfilter.valueForKey("outputImage") as! CIImage
        var blurredImage = UIImage(CIImage: resultImage)
        return blurredImage!
        
    }
    
    
    private func setupBackground(){
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        //self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        //self.view.addSubview(effectView)
        var bg2 = UIImageView(frame: self.view.frame)
        bg2.image = UIImage(named: "passport2.jpg")
        bg2.alpha = 0.1
        self.view.addSubview(bg2)
        
    }
    
    private func setupProfile(){
        
        var profilePic = UIImageView(image: LocalDAO.sharedInstance.getUserProfileImage())
        profilePic.frame.size = CGSizeMake(150, 150)
        profilePic.center = CGPointMake(self.view.center.x, self.view.bounds.height / 6)
        profilePic.layer.cornerRadius = 75
        profilePic.clipsToBounds = true
        self.view.addSubview(profilePic)
        
        var username = UILabel()
        username.frame.size = CGSizeMake(200, 40)
        username.center =  CGPointMake(self.view.center.x, self.view.frame.height / 3)
        username.textAlignment = .Center
        username.text = LocalDAO.sharedInstance.getUserName()
        username.font = UIFont(name: "AmaticSC-Regular", size: 40)
        self.view.addSubview(username)
    }
    
    private func setupUserStats(){
        
        
        var cinza = UIView(frame: CGRectMake(0, 0, self.view.frame.width , self.view.frame.height / 2.8))
        cinza.backgroundColor = UIColor.blackColor()
        cinza.alpha = 0.1
        cinza.center = CGPointMake( self.view.center.x , self.view.frame.height / 1.72)
        //self.view.addSubview(cinza)
        
        var blur2:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var effectView2:UIVisualEffectView = UIVisualEffectView (effect: blur2)
        effectView2.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height / 2.8)
        effectView2.center = CGPointMake( self.view.center.x , self.view.frame.height / 1.72)
        effectView2.alpha = 0.2
        self.view.addSubview(effectView2)
        
        var suitcase = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        suitcase.image = UIImage(named: "Suitcase")
        suitcase.center = CGPointMake(self.view.center.x, self.view.frame.height / 2.25)
        self.view.addSubview(suitcase)
        
        //        var numContries = LocalDAO.sharedInstance.getNumberOfVisitedCountries()
        self.statistic1 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 1.5, 50))
        self.statistic1.center = CGPointMake(self.view.center.x, self.view.frame.height / 2.0)
        self.statistic1.textAlignment = .Center
        self.statistic1.text = "5 different countries"
        self.statistic1.font = UIFont(name: "AmericanTypewriter", size: 18)
        //  self.statistic1.textColor = UIColor.whiteColor()
        self.view.addSubview(self.statistic1)
        
        var meeting = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        meeting.image = UIImage(named: "Meeting")
        meeting.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.8)
        self.view.addSubview(meeting)
        
        //        var numFriends = LocalDAO.sharedInstance.getNumberOfNewFriends()
        self.statistic2 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 1.5, 50))
        self.statistic2.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.65)
        self.statistic2.textAlignment = .Center
        self.statistic2.text = "15 new friends"
        self.statistic2.font = UIFont(name: "AmericanTypewriter", size: 18)
        //self.statistic2.textColor = UIColor.whiteColor()
        self.view.addSubview(self.statistic2)
        
        var food = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        food.image = UIImage(named: "Food")
        food.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.5)
        self.view.addSubview(food)
        
        //        var numRest = LocalDAO.sharedInstance.getNumberOfOfRestaurants()
        self.statistic3 = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 1.5, 50))
        self.statistic3.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.4)
        self.statistic3.textAlignment = .Center
        self.statistic3.text = "25 new restaurants"
        self.statistic3.font = UIFont(name: "AmericanTypewriter", size: 18)
        //self.statistic3.textColor = UIColor.whiteColor()
        self.view.addSubview(self.statistic3)
        
    }
    
    private func setupNavigationController(){
        var tripify = UIImageView(image: UIImage(named: "TripifyTitle2"))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.topItem?.titleView = tripify
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
    }
    
    //    func test(){
    //
    ////        var testMoment = Moment()
    /////Users/LeoWajnsztok/Desktop/Captura de Tela 2015-05-30 às 00.05.15.png
    ////        testMoment.changeGeoTag(CLLocation(latitude: 2423423, longitude: 234234234))
    ////        testMoment.addNewPhoto(UIImage(named: "teste")!)
    ////        testMoment.addNewPhoto(UIImage(named: "maria")!)
    ////        testMoment.addNewPhoto(UIImage(named: "arc")!)
    //
    //
    //        var appDelegate : AppDelegate
    //        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        var context = appDelegate.managedObjectContext
    //
    //
    //        var request : NSFetchRequest
    //        request = NSFetchRequest(entityName: "Moment")
    //
    //        var erro : NSError?
    //        var result : [Moment]
    //
    //        result = context!.executeFetchRequest(request, error: &erro)! as! [Moment]
    //        println(result.count)
    //
    //        var allImages : [UIImage]?
    //
    //        for moment in result{
    //            
    //            allImages = moment.getAllPhotos()
    //            println(allImages!.count)
    //        }
    //    }
}
