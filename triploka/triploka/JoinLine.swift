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
        
        var x1 = 0.05 * self.bounds.width
        var x2 = 0.55 * self.bounds.width
        var width = 0.4 * self.bounds.width
        var xLine1 = x1 + width
        var xLine2 = self.bounds.width/2
        var y = 20
        var lineWidth = self.bounds.width/2 - (x1 + width)
        
        var thickness = CGFloat(1)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, thickness)
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        
        var rar: [CGFloat] = [4,0]
        CGContextSetLineDash(context, 0.0, rar, 2)
        
        CGContextMoveToPoint(context, self.frame.width, self.frame.height/2)
        CGContextAddLineToPoint(context, self.bounds.width/2 - xLine2-x1/2, self.frame.height/2)
        CGContextStrokePath(context)
    }
    
}
