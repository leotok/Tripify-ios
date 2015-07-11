//
//  AddTripViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 28/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController,FlatImagePickerViewControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var titleTextField : UITextField!
    var titleLabel: UILabel!
    var cover: UIImageView!
    var dateLabel: UILabel!
    var datePicker: UIDatePicker!
    var input: UILabel!
    
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
        
        
        // config navigation controller
        
        self.navigationItem.title = "Add New Trip"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("doneButtonPressed"))
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        // inputs da trip
        
        titleLabel = UILabel()
        titleLabel.text = "Title:"
        titleLabel.frame.size = CGSizeMake(self.view.frame.width / 4.7, self.view.frame.width / 9.4 )
        titleLabel.center = CGPointMake(self.view.frame.width / 5, self.view.frame.width / 6.4)
        titleLabel.textColor = UIColor(red:0.1882, green:0.1922, blue:0.2157, alpha:1)
        self.view.addSubview(self.titleLabel)
        
        titleTextField = UITextField(frame: CGRectMake(0, 0, self.view.bounds.width / 1.7, 30))
        titleTextField!.center = CGPointMake(self.view.frame.width / 1.7, self.view.bounds.width / 6.4)
        titleTextField!.placeholder = "\(LocalDAO.sharedInstance.getUserName())'s Trip"
        titleTextField!.delegate = self
        titleTextField!.borderStyle = UITextBorderStyle.None
        titleTextField.textColor = UIColor(red:0.1882, green:0.1922, blue:0.2157, alpha:1)
        self.view.addSubview(titleTextField!)
        
        dateLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width / 4.7, self.view.frame.width / 9.4))
        dateLabel.text = "Began:"
        dateLabel.center = CGPointMake(self.view.frame.width / 5, self.view.frame.width / 4)
        dateLabel.textColor = UIColor(red:0.1882, green:0.1922, blue:0.2157, alpha:1)
        self.view.addSubview(self.dateLabel)
        
        datePicker = UIDatePicker()
        datePicker.frame = CGRectMake(0, 160, 320, 160)
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.grayColor().CGColor
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.transform = CGAffineTransformMakeScale( 0.8, 0.8)
        datePicker.center = CGPointMake(self.view.frame.width / 2, self.view.frame.width / 2)
        datePicker.datePickerMode = UIDatePickerMode.Date
        let currentDate = NSDate()
        datePicker.maximumDate = currentDate
        datePicker.date = currentDate
        self.view.addSubview(datePicker)

        cover = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width / 1.4, self.view.bounds.height / 2.8))
        cover.center = CGPointMake(self.view.center.x, self.view.frame.height / 1.7)
        cover.userInteractionEnabled = true
        cover.backgroundColor = UIColor.whiteColor()
        cover.layer.borderWidth = 1
        cover.layer.borderColor = UIColor.grayColor().CGColor
        var coverTap = UITapGestureRecognizer(target: self, action: Selector("chooseCover"))
        self.cover.addGestureRecognizer(coverTap)
        
        input = UILabel()
        input.text = "Add Cover"
        input.font = UIFont(name: "AmaticSC-Regular", size: 30)
        input.frame.size = CGSizeMake(120, 40)
        input.center = cover.center
        input.textAlignment = .Center
        
        self.view.addSubview(cover)
        self.view.addSubview(input)
        
        
        
    }
    
    // Delegates TextField
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = count(textField.text.utf16) + count(string.utf16) - range.length
        
        return length <= 20
        
    }
    
    // Camera e Gallery para cover
    
    func chooseCover() {
        self.titleTextField.resignFirstResponder()
        cover.userInteractionEnabled = false

        var flat = FlatImagePickerViewController(shouldSaveImage: (LocalDAO.sharedInstance.shouldSaveToPhotoGallery()))
        flat.delegate = self
        
        self.presentViewController(flat, animated: false, completion: nil)
    }
    
    func FlatimagePickerViewController(imagePicker: FlatImagePickerViewController, didSelectImage image: UIImage) {
        
        self.cover.image = image
        self.input.removeFromSuperview()
        
    }
    
    func FlatimagePickerViewControllerDidCancel(imagePicker: FlatImagePickerViewController) {
        
        cover.userInteractionEnabled = true
        
    }
    
    // volta e salva a trip criada
    
    func doneButtonPressed() {
        
        var newTrip = Trip()
        if self.cover.image != nil {
            newTrip.changePresentationImage(self.cover.image!)
        }
        else {
            newTrip.changePresentationImage(UIImage(named:"city-cars-traffic-lights.jpeg")!)
        }
        
        
        var stringWithoutWhitespace = titleTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let length = count(stringWithoutWhitespace.utf16)
        
        if self.titleTextField.text == nil || self.titleTextField.text.isEmpty || length == 0 {
            
            println("\(length)")
            newTrip.destination = "\(LocalDAO.sharedInstance.getUserName())'s Trip"
            
        }
        else
        {
            newTrip.destination = self.titleTextField.text!
        }
        
        
        newTrip.beginDate = datePicker.date
        
//        DAOCloudTrip.getInstance().saveInstruction(newTrip)
//        DAOCloudTrip.getInstance().updateCloudKit()
        
        self.navigationController?.popViewControllerAnimated(true)
    
    }
    
}