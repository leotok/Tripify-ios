//
//  AddTripViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 28/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController, UITextFieldDelegate{
    
    var titleTextField : UITextField!
    var cover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.title = "Add New Trip"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        var input = UILabel()
        cover = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width / 1.5, self.view.bounds.height / 3))
        cover.center = self.view.center
        input.text = "Add Cover Photo"
        input.frame.size = CGSizeMake(100, 40)
        input.center = cover.center
        input.textAlignment = .Center
        cover.addSubview(input)
        cover.layer.borderWidth = 1
        cover.layer.borderColor = UIColor.grayColor().CGColor
        self.view.addSubview(cover)
        
        titleTextField = UITextField(frame: CGRectMake(0, 0, self.view.bounds.width / 1.5, 30))
        titleTextField!.center = CGPointMake(self.view.center.x, self.view.bounds.height / 8)
        titleTextField!.placeholder = "Trip Title"
        titleTextField!.delegate = self
        titleTextField!.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(titleTextField!)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}