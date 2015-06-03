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

    override init (frame: CGRect)
    {
        super.init(frame: frame)
        
        
        
        tripTitle = UILabel()
        
        tripTitle.frame.size = CGSizeMake(self.frame.width / 1.5 , 100)
        tripTitle.center = CGPointMake(self.center.x, self.frame.height/1.3)
        tripTitle.textColor = UIColor.whiteColor()
        tripTitle.textAlignment = .Center
        tripTitle.numberOfLines = 2
        tripTitle.font = UIFont(name: "AmericanTypewriter", size: 35)
        tripCover = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
       
        
        self.addSubview(tripCover)
        self.addSubview(tripTitle)
        

    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
