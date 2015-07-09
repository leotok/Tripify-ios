//
//  SlideUpImagePickerViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 09/07/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class SlideUpImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var cinza: UIView!
    var camera: UIButton!
    var gallery: UIButton!
    var cancel: UIButton!
    var coverPicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
    }


    func chooseCover() {
        
        
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
        self.coverPicker.dismissViewControllerAnimated(true, completion: nil)
        
        if LocalDAO.sharedInstance.shouldSaveToPhotoGallery()
        {
            if picker.sourceType == UIImagePickerControllerSourceType.Camera
            {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        
    }
    
    func cancelPressed() {
        
        UIView.animateWithDuration(0.1, animations: {
            self.cinza.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height - self.view.bounds.height / 1.3)
            self.camera.removeFromSuperview()
            self.gallery.removeFromSuperview()
            self.cancel.removeFromSuperview()
        })
        
    }
    
}
