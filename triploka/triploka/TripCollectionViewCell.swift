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
    var tripDate: UILabel!
    var tripCover:      UIImageView!
    var priority: Int = 0
    private var cinza: UIView!

    override init (frame: CGRect)
    {
        super.init(frame: frame)

        
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame.size = CGSizeMake( self.frame.width  , 110)
        effectView.center = CGPointMake( self.center.x, self.frame.height / 1.4)
//        effectView.layer.cornerRadius = 5
        effectView.clipsToBounds = true
        

        tripDate = UILabel()
        tripDate.frame.size = CGSizeMake(self.frame.width / 1.2 , 60)
        tripDate.center = CGPointMake(self.center.x, self.frame.height/1.18)
        tripDate.textColor = UIColor.whiteColor()
        tripDate.textAlignment = .Center
        tripDate.numberOfLines = 2
        tripDate.font = UIFont(name: "AmericanTypewriter-Light", size: 18)
        tripDate.text = "- 1 day -"
        
        
        tripTitle = UILabel()
        tripTitle.frame.size = CGSizeMake(self.frame.width / 1.2 , 100)
        tripTitle.center = CGPointMake(self.center.x, self.frame.height/1.45)
        tripTitle.textColor = UIColor.whiteColor()
        tripTitle.textAlignment = .Center
        tripTitle.numberOfLines = 2
        tripTitle.font = UIFont(name: "AmericanTypewriter-Light", size: 35)
        tripCover = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
       
        
        self.addSubview(tripCover)
        self.addSubview(effectView)
        self.addSubview(tripTitle)
        self.addSubview(tripDate)
        

    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
