//
//  AboutUsViewController.swift
//  triploka
//
//  Created by Leonardo Edelman Wajnsztok on 11/06/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    var aboutLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        var bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)
        
        
        self.navigationItem.title = "About Us"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        self.aboutLabel.frame = CGRectMake(0, 0, self.view.frame.width / 1.3, self.view.frame.height / 1.3 )
        self.aboutLabel.center = CGPointMake(self.view.center.x, self.view.frame.height / 4)
        self.aboutLabel.numberOfLines = -1
        self.aboutLabel.text = "Developed by:\n\nJordan Rodrigues\nLeonardo E. Wajnsztok\nVictor Souza\nVictor Yves"
        self.aboutLabel.textAlignment = .Center
        
        self.view.addSubview(aboutLabel)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
