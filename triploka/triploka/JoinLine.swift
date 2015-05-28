//
//  JoinLine.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class JoinLine: UIView {
    
    override func drawRect(rect: CGRect) {
        
        var thickness = CGFloat(2)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, thickness)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        
        var rar: [CGFloat] = [4,0]
        CGContextSetLineDash(context, 0.0, rar, 2)
        
        CGContextMoveToPoint(context, self.frame.width, self.frame.height/2)
        CGContextAddLineToPoint(context, self.bounds.width/2, self.frame.height/2)
        CGContextStrokePath(context)
    }
    
}
