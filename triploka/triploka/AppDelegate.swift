//
//  AppDelegate.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 21/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//


import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate {
    
    var window: UIWindow?
    var viewController = SWRevealViewController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        if let window = window {
            
            let front = GenericViewController()
            let rear = MenuViewController()
            let frontNav = UINavigationController(rootViewController: front)
            let revealvc = SWRevealViewController(rearViewController: rear, frontViewController: frontNav)
            
            revealvc.rearViewRevealWidth = UIScreen.mainScreen().bounds.width / 1.23
            revealvc.rearViewRevealOverdraw = 0
            revealvc.bounceBackOnOverdraw = false
            revealvc.stableDragOnOverdraw = true
            revealvc.setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealvc.delegate = self
            
            self.viewController = revealvc

            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = revealvc
            window.makeKeyAndVisible()
        }
        
        LocalDAO.sharedInstance.loadObjectGraph()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        LocalDAO.sharedInstance.saveContext()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
       LocalDAO.sharedInstance.saveContext()
    }
    
}

