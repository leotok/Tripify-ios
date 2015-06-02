//
//  MomentOptions.swift
//  triploka
//
//  Created by Victor Souza on 5/30/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class MomentOptions: UIView {
    
    var icon: UIImage = UIImage()
    
    override func drawRect(rect: CGRect) {
        
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        
        var bg = UIImageView(image: icon)
        bg.frame = self.frame
        self.addSubview(bg)
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("addNew:"))
        self.addGestureRecognizer(tap)
        
    }
    
    
    func addNew(recognizer: UITapGestureRecognizer) {
        
        println(recognizer)
        
    }
    
}