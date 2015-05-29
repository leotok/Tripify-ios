//
//  DashedLine.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class DashedLine: UIView {
    
    override func drawRect(rect: CGRect) {
        
        var thickness = CGFloat(3)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, thickness)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        var rar: [CGFloat] = [4,2]
        CGContextSetLineDash(context, 0.0, rar, 2)
        
        CGContextMoveToPoint(context, 22, 0)
        CGContextAddLineToPoint(context, 22, self.bounds.height)
        CGContextStrokePath(context)
        
    }
    
}
