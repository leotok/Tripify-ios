//
//  AddTripViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 28/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var titleTextField : UITextField!
    var cover: UIImageView!
    var coverPicker: UIImagePickerController!
    var cinza: UIView!
    var camera: UIButton!
    var gallery: UIButton!
    var cancel: UIButton!
    var input: UILabel!
    
    
    
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
        
        self.input = UILabel()
        cover = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width / 1.4, self.view.bounds.height / 2.8))
        cover.center = CGPointMake(self.view.center.x, self.view.frame.height / 2.5)
        cover.userInteractionEnabled = true
        cover.backgroundColor = UIColor.whiteColor()
        input.text = "Add Cover"
        input.font = UIFont(name: "AmaticSC-Regular", size: 30)
        input.frame.size = CGSizeMake(120, 40)
        input.center = cover.center
        input.textAlignment = .Center
        cover.layer.borderWidth = 1
        cover.layer.borderColor = UIColor.grayColor().CGColor
        
        var coverTap = UITapGestureRecognizer(target: self, action: Selector("chooseCover"))
        self.cover.addGestureRecognizer(coverTap)
        
        self.view.addSubview(cover)
        self.view.addSubview(input)
        
        titleTextField = UITextField(frame: CGRectMake(0, 0, self.view.bounds.width / 1.5, 30))
        titleTextField!.center = CGPointMake(self.view.center.x, self.view.bounds.height / 8)
        titleTextField!.placeholder = "Trip Title"
        titleTextField!.delegate = self
        titleTextField!.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(titleTextField!)
        
        
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

        cinza = UIView(frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.25))
        cinza.backgroundColor = UIColor.blackColor()
        cinza.alpha = 0.6
        
        camera = UIButton(frame: CGRectMake(self.view.bounds.width / 4,self.view.frame.height, 80, 80))
        camera.setImage(UIImage(named: "Camera-50"), forState: UIControlState.Normal)
        camera.addTarget(self, action: Selector("cameraPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        gallery = UIButton(frame: CGRectMake(self.view.bounds.width * 3 / 4,self.view.frame.height, 80, 80))
        gallery.setImage(UIImage(named: "Picture-50"), forState: UIControlState.Normal)
        gallery.addTarget(self, action: Selector("galleryPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cancel = UIButton(frame: CGRectMake(self.view.center.x, self.view.bounds.height, self.view.bounds.width - 20, self.view.bounds.height / 10))
        cancel.setImage(UIImage(named: "Cancel-32"),forState: UIControlState.Normal)
        cancel.addTarget(self, action: Selector("cancelPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.camera.center = CGPointMake(self.view.bounds.width / 4 , self.view.frame.height)
        self.gallery.center = CGPointMake(self.cinza.bounds.width * 3 / 4 , self.view.frame.height)
        self.cancel.center = CGPointMake(self.view.center.x, self.view.bounds.height)
        
        
        self.view.addSubview(cinza)
        self.view.addSubview(gallery)
        self.view.addSubview(camera)
        self.view.addSubview(cancel)
        
        UIView.animateWithDuration(0.2, animations: {
            self.cinza.frame = CGRectMake(0, self.view.bounds.height / 1.25, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.25)
            self.camera.center = CGPointMake(self.view.bounds.width / 4 , self.view.frame.height / 1.15 )
            self.gallery.center = CGPointMake(self.cinza.bounds.width * 3 / 4 , self.view.frame.height / 1.15)
            self.cancel.center = CGPointMake(self.view.center.x, self.view.bounds.height / 1.05 )
        })
        
    }
    
    func galleryPressed() {
        
        self.coverPicker = UIImagePickerController()
        self.coverPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.coverPicker.delegate = self
        self.coverPicker.allowsEditing = true
        
        self.presentViewController(coverPicker, animated: true, completion: nil)
        self.cancelPressed()
    }
    
    func cameraPressed() {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
        self.coverPicker = UIImagePickerController()
        self.coverPicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.coverPicker.delegate = self
        self.coverPicker.allowsEditing = true
        
        self.presentViewController(coverPicker, animated: true, completion: nil)
        
        }
        self.cancelPressed()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.cover.image = image
        self.coverPicker.dismissViewControllerAnimated(true, completion: nil)
        self.input.removeFromSuperview()        
        
    }
    
    func cancelPressed() {
        cover.userInteractionEnabled = true
        
        UIView.animateWithDuration(0.1, animations: {
            self.cinza.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.3)
            self.camera.removeFromSuperview()
            self.gallery.removeFromSuperview()
            self.cancel.removeFromSuperview()
        })
        
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
        
        if self.titleTextField.text != nil && self.titleTextField.text.isEmpty {
            newTrip.destination = "\(LocalDAO.sharedInstance.getUserName())'s Trip"
        } else
        {
            newTrip.destination = self.titleTextField.text!
        }
        
        
        newTrip.beginDate = NSDate()
        
        self.navigationController?.popViewControllerAnimated(true)
    
    }
    
}