//
//  NewMomentController.swift
//  chp3
//
//  Created by Victor Souza on 5/26/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class NewMomentController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var img: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonDone   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        buttonDone.frame = CGRectMake(200, 100, 100, 50)
        buttonDone.backgroundColor = UIColor.greenColor()
        buttonDone.setTitle("Done", forState: UIControlState.Normal)
        buttonDone.addTarget(self, action: "done:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        self.view.addSubview(buttonDone)
        
        self.img = UIImageView(frame: CGRect(x: 10, y: 200, width: 100, height: 100))
        self.view.addSubview(img)
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Button capture")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let selectedImage : UIImage = image
        img.image = selectedImage

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func done(sender:UIButton!)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if self.img.image != nil {
        
            NSNotificationCenter.defaultCenter().postNotificationName("ModelViewDismiss", object: self.img.image)
        }
        
    }
    
}

