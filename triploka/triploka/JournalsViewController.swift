//
//  JournalsViewController.swift
//  chp3
//
//  Created by Leonardo Edelman Wajnsztok on 26/05/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class JournalsViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var sideMenuButton = UIBarButtonItem()
    var addButton : UIBarButtonItem?
    
    
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blurMenu"), forBarMetrics: UIBarMetrics.Default)
        let revealController :SWRevealViewController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        
        self.navigationController?.navigationBar.topItem?.title = "Journals"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addTrip"))
        addButton!.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = addButton
        
        
        sideMenuButton.tintColor = UIColor.whiteColor()
        sideMenuButton.image = UIImage(named: "Menu-25")
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
        
        
        if self.revealViewController() != nil{
            
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = Selector("revealToggle:")
        }
        
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        var collectionJournal = UICollectionView(frame: CGRectMake( 0, 0, self.view.frame.width, self.view.frame.height ), collectionViewLayout: layout)
        collectionJournal.dataSource = self
        collectionJournal.delegate = self
        collectionJournal.userInteractionEnabled = true
        collectionJournal.alwaysBounceVertical = true
        collectionJournal.scrollEnabled = true
        collectionJournal.registerClass(TripCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionJournal.backgroundColor = UIColor.clearColor()
        
        
        self.view.addSubview(collectionJournal)
        
    }
    
    func addTrip()
    {
        let addvc = AddTripViewController()
        self.navigationController?.pushViewController(addvc, animated: true)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell : TripCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as? TripCollectionViewCell
        
        println(indexPath.row)
        // pegar vetor de trips do DAO usar aqui
        
        if indexPath.row == 0
        {
            cell!.tripTitle.text = "Portugal"
            cell!.tripCover.image = UIImage(named: "maria")
            cell!.priority = 1
        }
        else if indexPath.row == 1
        {
            cell!.tripTitle.text = "França"
            cell!.tripCover.image = UIImage(named: "arc.jpg")
            cell!.priority = 2
        }
        else
        {
            cell!.tripTitle.text = "Lixo"
            cell!.tripCover.image = UIImage(named: "maria")
            cell!.priority = 2
            
        }
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("showTimeline"))
        cell?.addGestureRecognizer(tap)
        
        return cell!
        
    }
    
    
    func showTimeline()
    {
        var timeline = TimelineController()
        self.navigationController?.pushViewController(timeline, animated: true)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //aqui ira o count do das trips
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        //pegar do DAO as prioritys de cada journal, tem q ser antes de criar as cells pq nao tem acesso a elas daqui
        return CGSizeMake(self.view.frame.width , self.view.frame.height/2)
        
        //        if indexPath.row == 0 // || indexPath.row == 3
        //        {
        //            println(indexPath.row)
        //            return CGSizeMake(self.view.frame.width , self.view.frame.height/2)
        //        }
        //        else
        //        {
        //            return CGSizeMake(self.view.frame.width/2.1, self.view.frame.height/4.2)
        //        }
        
    }
    
}
