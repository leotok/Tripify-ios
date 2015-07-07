//
//  TripCollectionViewCell.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 26/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell, UITextFieldDelegate
{
    
    var tripTitle:      UILabel!
    var tripTextField: UITextField!
    var tripDate: UILabel!
    var tripCover:      UIImageView!
    var priority: Int = 0
    var trip: Trip!
    
    private var cinza: UIView!

    override init (frame: CGRect)
    {
        super.init(frame: frame)

        
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame.size = CGSizeMake( self.frame.width  , self.frame.width / 3.41)
        effectView.center = CGPointMake( self.center.x, self.frame.height / 1.4)
        effectView.clipsToBounds = true
        

        tripDate = UILabel()
        tripDate.frame.size = CGSizeMake(self.frame.width / 1.2 , 60)
        tripDate.center = CGPointMake(self.center.x, self.frame.height/1.17)
        tripDate.textColor = UIColor.whiteColor()
        tripDate.textAlignment = .Center
        tripDate.numberOfLines = 2
        tripDate.font = UIFont(name: "AmericanTypewriter-Light", size: self.frame.width / 20)
        tripDate.text = "- 1 day -"
        
        
        tripTitle = UILabel()
        tripTitle.frame.size = CGSizeMake(self.frame.width / 1.2 , 100)
        tripTitle.center = CGPointMake(self.center.x, self.frame.height/1.45)
        tripTitle.textColor = UIColor.whiteColor()
        tripTitle.textAlignment = .Center
        tripTitle.numberOfLines = 2
        tripTitle.font = UIFont(name: "AmericanTypewriter-Light", size: self.frame.height / 9)
        tripCover = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
       
        tripTextField = UITextField()
        tripTextField.delegate = self
        tripTextField.frame.size = CGSizeMake(self.frame.width / 1.2 , 100)
        tripTextField.center = CGPointMake(self.center.x, self.frame.height/1.45)
        tripTextField.borderStyle = UITextBorderStyle.None
        tripTextField.textColor = UIColor.whiteColor()
        tripTextField.tintColor = UIColor.whiteColor()
        tripTextField.textAlignment = .Center
        tripTextField.font = UIFont(name: "AmericanTypewriter-Light", size: self.frame.height / 9)
        tripTextField.hidden = true
        
        var gesture = UILongPressGestureRecognizer(target: self, action: Selector("longPressToEdit"))
        self.addGestureRecognizer(gesture)
        
        
        self.addSubview(tripCover)
        self.addSubview(effectView)
        self.addSubview(tripTitle)
        self.addSubview(tripTextField)
        self.addSubview(tripDate)
        

    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tripTextField.hidden = true
        trip.destination = tripTextField.text
        tripTitle.text = tripTextField.text
        tripTitle.hidden = false
        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = count(textField.text.utf16) + count(string.utf16) - range.length
        
        return length <= 20
        
    }
    
    func longPressToEdit() {
     
        tripTitle.hidden = true
//        tripTextField.text = tripTitle.text
        tripTextField.hidden = false
        
        
    }
    
}
