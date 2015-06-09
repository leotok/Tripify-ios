//
//  SettingsViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 09/06/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{

    var sideMenuButton = UIBarButtonItem()
    var settingsTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    var nameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // background
       
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)
        
        
        // Config navigation controller
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        let revealController :SWRevealViewController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        sideMenuButton.tintColor = UIColor.whiteColor()
        sideMenuButton.image = UIImage(named: "Menu-25")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
        }
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.frame = self.view.frame
        settingsTableView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(settingsTableView)
    

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = count(textField.text.utf16) + count(string.utf16) - range.length
        
        return length <= 20
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return "Profile"
        }
        else if section == 1
        {
            return "General"
        }
        else
        {
            return "About"
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "menuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        if indexPath.section == 0
        {
            if (indexPath.row == 0)
            {
                cell?.textLabel?.text = "Name"
                cell?.userInteractionEnabled = false
                self.nameTextField.frame.size = CGSizeMake( self.view.frame.width / 2 , self.view.frame.height / 2)
                self.nameTextField.center = CGPointMake(self.view.center.x, self.view.bounds.height / 7.5)
                self.nameTextField.placeholder = "Your name"
                self.nameTextField.delegate = self
                self.nameTextField.borderStyle = UITextBorderStyle.None
                self.view.addSubview(self.nameTextField)
            }
            else
            {
                cell?.textLabel?.text = "Picture"
            }

        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                cell?.textLabel?.text = "Save pictures taken"
            }
            else
            {
                cell?.textLabel?.text = "Delete all trips"
            }
        }
        else
        {
            if indexPath.row == 0
            {
                cell?.textLabel?.text = "What's new"
            }
            else
            {
                cell?.textLabel?.text = "Us"
            }
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
        
            }
            else
            {
                let alertController = UIAlertController(title: "Are you sure?", message: "You'll lose all of your recorded moments.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)  { (action) in println(action) }
                alertController.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { action -> Void in LocalDAO.sharedInstance.deleteAllTrips() }
                alertController.addAction(deleteAction)
                
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                let alertController = UIAlertController(title: "What's New", message: "Version 0.9:\n- Add as many trips as you want\n- Record and remember your favourite trip's moments", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)  { (action) in println(action) }
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)

            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }


}
