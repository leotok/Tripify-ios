//
//  TestMoment.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TestMoment: UIView {
    
    var image: UIImageView = UIImageView()
    var deltaY: CGFloat = 120
    var originalFrame: CGPoint = CGPoint()
    
    override func drawRect(rect: CGRect) {
        
        self.image.frame = self.frame
        self.addSubview(self.image)
        originalFrame = self.frame.origin
        var gesture = UILongPressGestureRecognizer(target: self, action: Selector("teste:"))
        self.addGestureRecognizer(gesture)
        
        
    }
    
    func teste(recognizer: UILongPressGestureRecognizer) {
        
        
        if recognizer.state == .Began {
            
            originalFrame = self.frame.origin
            
            UIView.animateWithDuration(0.2, animations: {
                
                self.frame.origin = recognizer.locationInView(self.superview)
                
            })
            
        }
        
        else if recognizer.state == .Changed {
            
            self.frame.origin = recognizer.locationInView(self.superview)
            NSNotificationCenter.defaultCenter().postNotificationName("ScrollNotification", object: self)
            
            
        }
        
        else if recognizer.state == .Ended {
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("ViewHold", object: self)
            
        }
    }
    
    func sendNotification() {
        
        
        
    }
    
    
}
