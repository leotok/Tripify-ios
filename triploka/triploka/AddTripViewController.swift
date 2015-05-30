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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "blurMenu")
        bg.alpha = 0.1
        self.view.addSubview(bg)
        
        self.navigationItem.title = "Add New Trip"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("doneButtonPressed"))
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        var input = UILabel()
        cover = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width / 1.4, self.view.bounds.height / 2.8))
        cover.center = CGPointMake(self.view.center.x, self.view.frame.height / 2.5)
        cover.userInteractionEnabled = true
        input.text = "Add Cover"
        input.font = UIFont(name: "AmaticSC-Regular", size: 30)
        input.frame.size = CGSizeMake(120, 40)
        input.center = cover.center
        input.textAlignment = .Center
        self.view.addSubview(input)
        cover.layer.borderWidth = 1
        cover.layer.borderColor = UIColor.grayColor().CGColor
        
        var coverTap = UITapGestureRecognizer(target: self, action: Selector("chooseCover"))
        self.cover.addGestureRecognizer(coverTap)
        
        self.view.addSubview(cover)
        
        titleTextField = UITextField(frame: CGRectMake(0, 0, self.view.bounds.width / 1.5, 30))
        titleTextField!.center = CGPointMake(self.view.center.x, self.view.bounds.height / 8)
        titleTextField!.placeholder = "Trip Title"
        titleTextField!.delegate = self
        titleTextField!.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(titleTextField!)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func chooseCover() {
        cover.userInteractionEnabled = false
        
        println("oi")
        cinza = UIView(frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.3))
        cinza.backgroundColor = UIColor.blackColor()
        cinza.alpha = 0.6
        
        camera = UIButton(frame: CGRectMake(0,0, 80, 80))
        camera.center = CGPointMake(self.view.bounds.width / 3.5 , self.view.frame.height - 80)
        camera.setImage(UIImage(named: "Camera-50"), forState: UIControlState.Normal)
        camera.addTarget(self, action: Selector("cameraPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        gallery = UIButton(frame: CGRectMake(0,0, 80, 80))
        gallery.center = CGPointMake(self.cinza.bounds.width / 1.45 , self.view.frame.height - 80)
        gallery.setImage(UIImage(named: "Picture-50"), forState: UIControlState.Normal)
        gallery.addTarget(self, action: Selector("galleryPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cancel = UIButton(frame: CGRectMake(10, self.view.bounds.height / 1.1 , self.view.bounds.width - 20, self.view.bounds.height / 10))
        cancel.setImage(UIImage(named: "Cancel-32"),forState: UIControlState.Normal)
        cancel.addTarget(self, action: Selector("cancelPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(cinza)
        self.view.addSubview(gallery)
        self.view.addSubview(camera)
        self.view.addSubview(cancel)
        
        UIView.animateWithDuration(0.1, animations: {
            self.cinza.frame = CGRectMake(0, self.view.bounds.height / 1.3, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.3)
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
    
    func doneButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}