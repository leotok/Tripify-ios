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
                
                
                self.layer.shadowOffset = CGSize(width: self.frame.size.width+10, height: self.frame.size.height+10)
                
            })
            
        }
            
        else if recognizer.state == .Changed {
            
            var center = getCenter(self.frame)
            
            var moveByX = recognizer.locationInView(self.superview).x - self.frame.midX
            var moveByY = recognizer.locationInView(self.superview).y - self.frame.midY
            
            self.frame.origin.x += moveByX
            self.frame.origin.y += moveByY
            NSNotificationCenter.defaultCenter().postNotificationName("ScrollNotification", object: self)
            
            
        }
            
        else if recognizer.state == .Ended {
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("ViewHold", object: self)
            
        }
    }
    
    func getCenter(rect: CGRect) -> CGPoint {
        
        return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
    }
    
}
