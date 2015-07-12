//
//  SettingsViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 09/06/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, FlatImagePickerViewControllerDelegate, UINavigationControllerDelegate{

    var sideMenuButton = UIBarButtonItem()
    var checkButotn = UIImageView()
    var settingsTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    var nameTextField = UITextField()
    var coverPicker: UIImagePickerController!
    var cinza: UIView!
    var camera: UIButton!
    var gallery: UIButton!
    var cancel: UIButton!
    var pictureCell: UITableViewCell?
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
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
        sideMenuButton.image = UIImage(named: "menuButton")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
            revealController.viewDisabled = settingsTableView
        }
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.frame = self.view.frame
        settingsTableView.backgroundColor = UIColor.clearColor()
        settingsTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
        settingsTableView.scrollEnabled = true
        
        self.view.addSubview(settingsTableView)
    

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //self.cancelPressed()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text != "" {
            
            LocalDAO.sharedInstance.setUserName(textField.text)
        }
        
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
                cell?.selected = false
                self.nameTextField.frame.size = CGSizeMake( self.view.frame.width / 2 , 40)
                self.nameTextField.center = CGPointMake(self.view.center.x, cell!.center.y * 1.15)
                self.nameTextField.placeholder = LocalDAO.sharedInstance.getUserName()
                self.nameTextField.delegate = self
                self.nameTextField.borderStyle = UITextBorderStyle.None
                cell!.addSubview(self.nameTextField)
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
                checkButotn.frame.size = CGSizeMake( self.view.frame.width / 12.5, self.view.frame.width / 12.5)
                checkButotn.center = CGPointMake(self.view.frame.width / 1.2, cell!.center.y * 1.15)
                println("\(self.view.frame.height)")
                if LocalDAO.sharedInstance.shouldSaveToPhotoGallery()
                {
                     checkButotn.image = UIImage(named: "Checked")
                }
                else
                {
                     checkButotn.image = UIImage(named: "Unchecked")
                }
                cell?.addSubview(self.checkButotn)
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
                cell?.textLabel?.text = "Info"
            }
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0
        {
            if indexPath.row == 1
            {
                self.chooseCover()
                self.pictureCell = tableView.cellForRowAtIndexPath(indexPath)
                tableView.cellForRowAtIndexPath(indexPath)?.userInteractionEnabled = false
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                if LocalDAO.sharedInstance.shouldSaveToPhotoGallery()
                {
                    checkButotn.image = UIImage(named: "Unchecked")
                    LocalDAO.sharedInstance.changePhotoGallerySavingPolicy(false)
                }
                else
                {
                    checkButotn.image = UIImage(named: "Checked")
                    LocalDAO.sharedInstance.changePhotoGallerySavingPolicy(true)
                }
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
            else if indexPath.row == 1
            {
                var about = AboutUsViewController()
                self.navigationController?.pushViewController(about, animated: true)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    // Camera e Gallery para cover
    
    func chooseCover() {
        self.nameTextField.resignFirstResponder()
        
        var flat = FlatImagePickerViewController(shouldSaveImage: (LocalDAO.sharedInstance.shouldSaveToPhotoGallery()))
        flat.delegate = self
        self.presentViewController(flat, animated: false, completion: nil)
        
    }
    
    func FlatimagePickerViewController(imagePicker: FlatImagePickerViewController, didSelectImage image: UIImage) {
        
        LocalDAO.sharedInstance.setUserProfileImage(image)
        
    }
    
    func FlatimagePickerViewControllerDidCancel(imagePicker: FlatImagePickerViewController) {
        
        self.pictureCell?.userInteractionEnabled = true
    }

}
