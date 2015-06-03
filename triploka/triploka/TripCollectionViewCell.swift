//
//  TripCollectionViewCell.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 26/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell
{
    
    var tripTitle:      UILabel!
    var tripStatistics: UILabel!
    var tripCover:      UIImageView!
    var priority: Int = 0
    private var cinza: UIView!

    override init (frame: CGRect)
    {
        super.init(frame: frame)
        
        cinza = UIView()
        cinza.frame.size = CGSizeMake( self.frame.width / 1.3 , 100)
        cinza.center = CGPointMake( self.center.x, self.frame.height / 1.5)

        
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame.size = CGSizeMake( self.frame.width / 1.3 , 100)
        effectView.center = CGPointMake( self.center.x, self.frame.height / 1.5)
        effectView.layer.cornerRadius = 5
        effectView.clipsToBounds = true
        

        
        
        tripTitle = UILabel()
        
        tripTitle.frame.size = CGSizeMake(self.frame.width / 1.5 , 100)
        tripTitle.center = CGPointMake(self.center.x, self.frame.height/1.5)
        tripTitle.textColor = UIColor.whiteColor()
        tripTitle.textAlignment = .Center
        tripTitle.numberOfLines = 2
        tripTitle.font = UIFont(name: "AmericanTypewriter-Light", size: 35)
        tripCover = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
       
        
        self.addSubview(tripCover)
        self.addSubview(effectView)
        self.addSubview(tripTitle)
        

    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
