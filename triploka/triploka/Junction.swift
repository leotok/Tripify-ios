//
//  Junction.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class Junction: UIView {
    
    override func drawRect(rect: CGRect) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = self.frame.width/10
    }
    
}