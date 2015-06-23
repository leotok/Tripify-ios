//
//  MenuViewController.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 25/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var tableViewMenu = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    var userName = UILabel()
    var presentedRow = Int()
    var profilePic = UIImageView()
    
    override func viewWillAppear(animated: Bool) {
        profilePic.image = LocalDAO.sharedInstance.getUserProfileImage()
        self.userName.text = LocalDAO.sharedInstance.getUserName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bgImage = UIImageView(image: UIImage(named: "blurMenu"))
        bgImage.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        
        self.tableViewMenu.frame = CGRectMake(0, (self.view.frame.size.height) / 4, self.view.frame.size.width, self.view.frame.size.height)
        self.userName.frame = CGRectMake(0, 0, self.view.frame.width / 1.875, self.view.frame.height / 7.65 )
        self.userName.center = CGPointMake( self.view.frame.width / (1.23 * 2), self.view.frame.height / 3.9 )

        self.userName.textColor = UIColor.whiteColor()
        self.userName.textAlignment = .Center
        self.userName.font = UIFont(name: "AmaticSC-Regular", size: self.view.frame.width / 11.718)
        
        
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        profilePic.layer.borderWidth = 1
        profilePic.frame.size = CGSizeMake( self.view.frame.width / 3.5, self.view.frame.width / 3.5)
        profilePic.center = CGPointMake( self.view.frame.width / (1.23 * 2) , self.view.bounds.height / 7.5)
        profilePic.layer.cornerRadius = self.view.frame.width / 7
        profilePic.clipsToBounds = true

        
        
        //self.tableViewMenu.setEditing(false, animated: false)
        self.tableViewMenu.backgroundColor = UIColor.clearColor()
        self.tableViewMenu.bounces = false
        self.tableViewMenu.delegate = self
        self.tableViewMenu.dataSource = self

        self.view.addSubview(bgImage)
        self.view.addSubview(userName)
        self.view.addSubview(tableViewMenu)
        self.view.addSubview(profilePic)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let revealController = revealViewController()
        
        if indexPath.row == presentedRow
        {
            revealController.setFrontViewPosition(FrontViewPosition.Left, animated: true)
        }
        else if indexPath.row == 2
        {
            revealController.setFrontViewPosition(FrontViewPosition.RightMost, animated: true)
        }
        else if indexPath.row == 3
        {
            revealController.setFrontViewPosition(FrontViewPosition.Right, animated: true)
        }
        
        var newFrontController: UIViewController
        
        if indexPath.row == 0
        {
            newFrontController =  UINavigationController(rootViewController: GenericViewController())
        }
        else if indexPath.row == 1
        {
            newFrontController =  UINavigationController(rootViewController: JournalsViewController())
            newFrontController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        }
        else
        {
            newFrontController =  UINavigationController(rootViewController: SettingsViewController())
        }
        
        revealController.pushFrontViewController(newFrontController, animated: true)
        presentedRow = indexPath.row

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "menuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        if (indexPath.row == 0)
        {
            cell?.textLabel?.text = "Passport"
        }
        else if (indexPath.row == 1)
        {
            cell?.textLabel?.text = "Journals"
        }
        else if (indexPath.row == 2)
        {
            cell?.textLabel?.text = "Settings"
        }

        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.font = UIFont(name: "AmaticSC-Regular", size: self.view.frame.width / 10.888)
        
        return cell!
    }
    
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      
        return 60
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
}
