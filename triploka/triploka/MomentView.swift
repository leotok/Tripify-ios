//
//  MomentView.swift
//  triploka
//
//  Created by Jordan Rodrigues Rangel on 6/12/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class MomentView : UIView {
    
    var moment : Moment! = nil
    var lastOrigin : CGPoint = CGPoint()
    var contentView : UIView! = nil
    var move = Bool()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    init(frame: CGRect, moment: Moment) {
        
        self.moment = moment
        
        super.init(frame: frame)
        self.clipsToBounds = true
        
        let category : Int32 = moment.category!.intValue
        
        if category == MomentCategory.Text.rawValue {
            
            var label : UILabel = UILabel(frame: frame)
            label.text = moment.comment!
            label.textAlignment = NSTextAlignment.Center
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.backgroundColor = UIColor.whiteColor()
            label.textColor = UIColor.blackColor()
            //label.center = self.center
            
            self.contentView = label
            //self.addSubview(label)
        }
        else if category == MomentCategory.Image.rawValue {
            
            var imageView : UIImageView = UIImageView(image: moment.getAllPhotos()[0])
            imageView.frame = frame
            //imageView.center = self.center
            
            self.contentView = imageView
            //self.addSubview(imageView)
        }
        
        var gesture = UILongPressGestureRecognizer(target: self, action: Selector("longPressToSwapMoment:"))
        self.addGestureRecognizer(gesture)
        self.lastOrigin = self.frame.origin
    }
    
    func animate() {
        
        if self.contentView != nil {
            
            self.contentView.frame = self.frame
            
            let category : Int32 = self.moment.category!.intValue
            
            if category == MomentCategory.Text.rawValue {
                
                let label : UILabel = self.contentView as! UILabel
                
                label.frame = self.frame
                label.textAlignment = .Center
                label.textColor = UIColor.blackColor()
            }
        }
        
        self.move = false
    }
    
    func normalState(type: Int) {
        
        if type == 0
        {
            self.contentView.frame.origin.x = self.frame.origin.x - 10
            self.contentView.frame.origin.y = self.frame.origin.y - 10
        }
        else if type == 1
        {
            self.contentView.center = self.center
        }
        self.addSubview(self.contentView)
        self.move = true
        
    }
    
    func longPressToSwapMoment(recognizer: UILongPressGestureRecognizer) {
        
        if self.move {
            
            if recognizer.state == .Began {
                
                self.lastOrigin = self.frame.origin
                
                UIView.animateWithDuration(0.2, animations: {
                    
                    self.alpha -= 0.3
                    self.superview?.bringSubviewToFront(self)
                    
                })
                
            }
                
            else if recognizer.state == .Changed {
                
                var center = self.center
                
                var moveByX = recognizer.locationInView(self.superview).x - self.frame.midX
                var moveByY = recognizer.locationInView(self.superview).y - self.frame.midY
                
                self.frame.origin.x += moveByX
                self.frame.origin.y += moveByY
                NSNotificationCenter.defaultCenter().postNotificationName("ScrollNotification", object: self)
                
                
            }
                
            else if recognizer.state == .Ended {
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("ViewHold", object: self)
                self.alpha += 0.3
                
            }
        }
    }
}