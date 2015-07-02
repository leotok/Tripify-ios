//
//  TimelineController.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TimelineController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /*********************************************
    *
    *  MARK: - Properties
    *
    ***/
    
    var tapEvent = UITapGestureRecognizer()
    var tapHoldEvent = UILongPressGestureRecognizer()
    
    var scrollView = UIScrollView()
    
    var offset = CGFloat(20)
    var size = CGFloat(100)
    
    var trip : Trip! = nil
    
    var x1: CGFloat = CGFloat()
    var x2: CGFloat = CGFloat()
    var xLine1: CGFloat = CGFloat()
    var xLine2: CGFloat = CGFloat()
    var width: CGFloat = CGFloat()
    var lineWidth: CGFloat = CGFloat()
    var totalHeight: CGFloat = CGFloat()
    var returnX: CGFloat = CGFloat()
    var returnY: CGFloat = CGFloat()
    var returnWidth: CGFloat = CGFloat()
    var returnHeight: CGFloat = CGFloat()
    var max: Int = Int()
    
    var yArray: [CGFloat] = [CGFloat]()
    var momentsViews: [MomentView] = [MomentView]()
    var lineTestArray: [JoinLine] = [JoinLine]()
    var junctionTestArray: [Junction] = [Junction]()
    
    var dashed: DashedLine = DashedLine()
    var pointJunction: Junction = Junction()
    
    var image: UIImage = UIImage()
    
    var textLabel: UILabel = UILabel()
    
    var teste: MomentView = MomentView()
    
    var testMoment: TestMoment = TestMoment()
    

    
    /*********************************************
    *
    *  MARK: - UIViewController Methods
    *
    ***/
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Trip"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"holdNotificationHandler:", name: "ViewHold", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"scrollNotification:", name: "ScrollNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"newPicture:", name: "PictureMoment", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"newText:", name: "TextMoment", object: nil)
        
        setupBackground()
        
        //Add ScrollView
        
        addScrollView()
        
        //Add TapEvent
        
        tapEvent = UITapGestureRecognizer(target: self, action:Selector("addEvent:"))
        tapHoldEvent = UILongPressGestureRecognizer(target: self, action: Selector("holdEvent:"))
        
        //Add Moments
        
        addMoments()
        
        totalHeight += 100
        
        updateContentSize(totalHeight)
    }
    
    
    
    /*********************************************
    *
    *  MARK: - Notification Methods
    *
    ***/
    
//    private func yourNotificationHandler(notice: NSNotification) {
//        
//        var image = UIImageView()
//        
//        image = notice.object as! UIImage
//        //        self.organizeMoments(self.point.y, image: self.image)
//        
//        self.substituteView(0)
//        
//    }
  
     func scrollNotification(notice: NSNotification) {
        
        var object = notice.object as! MomentView
        
        var visibleRect = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y + self.scrollView.bounds.size.height)
        
        var min = self.view.bounds.height + self.scrollView.contentOffset.y
        
        if object.frame.maxY > 0.9 * visibleRect.size.height && visibleRect.height < self.totalHeight{
            
            self.scrollView.contentOffset.y += 15
            
        }
            
        else if object.frame.minY < self.scrollView.contentOffset.y + 20 && self.scrollView.contentOffset.y > 0 {
            
            self.scrollView.contentOffset.y -= 15
            
        }
        
    }
    
     func holdNotificationHandler(notice: NSNotification) {
        
        var moved = false
        
        self.teste = notice.object as! MomentView
        moved = true
        var index = Int(0)
        var indexOriginal = Int(0)
        var center = CGPoint(x: self.teste.frame.midX, y: self.teste.frame.midY)
        
        
        for var i = 0; i < self.momentsViews.count; i++ {
            
            if CGRectContainsPoint(self.momentsViews[i].frame, center) && self.momentsViews[i].frame.origin != self.teste.frame.origin {
                
                index = i
                
            }
                
            else if CGRectContainsPoint(self.momentsViews[i].frame, center) && self.momentsViews[i].frame.origin == self.teste.frame.origin {
                
                indexOriginal = i
                
            }
            
        }
        
        swap(index)
        changeOrder(index, second: indexOriginal)
        
    }

     func newPicture(notice: NSNotification) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Button capture")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }
        
    }
    
     func newText(notice: NSNotification) {
        
        println("newText")
        self.textLabel.text = "hello"
        
        let moment : Moment = Moment()
        
        moment.comment = self.textLabel.text
        moment.category = NSNumber(int: MomentCategory.Text.rawValue)
        
        self.trip.addNewMoment(moment)
        
        let currentView : MomentView = self.momentsViews[self.max]
        let momentView : MomentView = MomentView(frame: currentView.frame, moment: moment)
        
        self.momentsViews[self.max] = momentView
        
        currentView.removeFromSuperview()
        self.scrollView.addSubview(momentView)
        self.testMoment.removeFromSuperview()
        
        self.substituteView( 1 )
    }
    
    
    
    /*********************************************
    *
    *  MARK: - UImagePickerDelegate Methods
    *
    ***/
    
     func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let selectedImage : UIImage = image
        self.image = selectedImage
        
        let moment : Moment = Moment()
        
        moment.category = NSNumber(int: MomentCategory.Image.rawValue)
        moment.addNewPhoto(image)
        moment.comment = "img"
        moment.trip = self.trip
        
        self.trip.addNewMoment(moment)
        
        let currentView : MomentView = self.momentsViews[self.max]
        let momentView : MomentView = MomentView(frame: currentView.frame, moment: moment)
        
        self.momentsViews[self.max] = momentView
        
        currentView.removeFromSuperview()
        self.scrollView.addSubview(momentView)
        self.testMoment.removeFromSuperview()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.substituteView( 0 )
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }
    
    
    /*********************************************
    *
    *  MARK: - Private Methods
    *
    ***/
    
     private func setupBackground(){
        
        self.view.backgroundColor = UIColor.whiteColor()
        let bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame

        self.view.addSubview(effectView)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
     private func addMoments() {
        
        x1 = 0.05 * self.view.bounds.width
        x2 = 0.55 * self.view.bounds.width
        width = 0.4 * self.view.bounds.width
        xLine1 = x1 + width
        xLine2 = self.view.bounds.width/2
        var y = offset
        lineWidth = self.view.frame.size.width/2 - (x1 + width)
        
        
        let moments : [Moment] = self.trip.getAllMoments()
        
        var momentsCount = 2 + moments.count
        var momentsIterator = 0
        
        for var i = 0; i < momentsCount; i++ {
            
            var height = CGFloat(0)
            var xSide = CGFloat(0)
            var xLine = CGFloat(0)
            
            if i%2 == 0 {
                
                xSide = x1
                xLine = xLine1
            }
                
            else {
                
                xSide = x2
                xLine = xLine2
            }
            
            let momentFrame : CGRect = CGRectMake(xSide, y, width, size)
            var momentView : MomentView
            
            
            var joinLine = JoinLine()
            joinLine.backgroundColor = UIColor.grayColor()
            joinLine.frame = CGRectMake(xLine, y + size/2, lineWidth, 1)
            self.scrollView.addSubview(joinLine)
            self.lineTestArray.append(joinLine)
            
            var junction = Junction()
            junction.backgroundColor = UIColor.whiteColor()
            junction.frame = CGRectMake(xLine2-x1/3, y+size/2-x1/3, x1/1.5, x1/1.5)
            self.scrollView.addSubview(junction)
            self.junctionTestArray.append(junction)
            
            self.yArray.append(junction.frame.origin.y)
            
            if i == 0 || (i == momentsCount-1) {
                
                momentView = MomentView(frame: momentFrame)
                momentView.hidden = true
                joinLine.hidden = true
            }
            else {
                
                var moment : Moment = moments[momentsIterator++]
                momentView = MomentView(frame: momentFrame, moment: moment)
                momentView.hidden = false
            }
            
            height = 120 // deltaY ??
            
            totalHeight += height
            y += height
            
            self.momentsViews.append(momentView)
            self.scrollView.addSubview(momentView)
        }
        
    }
    
     private func organizeMoments(createPoint: CGFloat) {
        
        totalHeight += self.size + self.offset
        self.updateContentSize(totalHeight)
        
        var absArray: [CGFloat] = [CGFloat]()
        
        absArray.removeAll(keepCapacity: false)
        
        for var i = 0; i < self.yArray.count; i++ {
            
            var difference = createPoint - self.yArray[i]
            absArray.append(abs(difference))
            
        }
        
        var min = minElement(absArray)
        
        var maximo = CGFloat(1000)
        
        for var i = 0; i < absArray.count; i++ {
            
            if min == absArray[i] {
                
                maximo = CGFloat(i)
                absArray[i] = 1000
                
            }
            
        }
        
        var maximo2 = CGFloat(1000)
        
        min = minElement(absArray)
        
        for var j = 0; j < absArray.count; j++ {
            
            if min == absArray[j] {
                
                maximo2 = CGFloat(j)
                
            }
            
        }
        
        maximo2 = returnMax(maximo, max2:maximo2)
        
        var newMomentY = self.momentsViews[Int(maximo2)].frame.origin.y
        var newMomentX = self.momentsViews[Int(maximo2)].frame.origin.x
        var newLineX = CGFloat(0)
        
        for var k = Int(maximo2); k < self.momentsViews.count; k++ {
            
            var x = self.momentsViews[k].frame.origin.x
            var y = self.momentsViews[k].frame.origin.y
            
            var newX = CGFloat(0)
            var lineX = CGFloat(0)
            
            if x == self.x1 {
                
                newX = self.x2
                lineX = self.xLine2
                
            }
                
            else {
                
                newX = self.x1
                lineX = self.xLine1
                
            }
            
            if newMomentX == self.x1 {
                
                newLineX = self.xLine1
                
            }
                
            else {
                
                newLineX = self.xLine2
                
            }
            
            self.yArray[k] += self.offset + self.size
            
            UIView.animateWithDuration(0.5, animations: {
                self.momentsViews[k].frame.origin = CGPoint(x: newX, y: y + self.offset + self.size)
                self.lineTestArray[k].frame.origin.y += self.offset + self.size
                self.lineTestArray[k].frame.origin.x = lineX
                self.junctionTestArray[k].frame.origin.y += self.offset + self.size
            })
            
            self.momentsViews[k].lastOrigin = self.momentsViews[k].frame.origin
            
        }
        
        var momentView = MomentView()
        momentView.frame = CGRectMake(self.view.bounds.width, newMomentY, self.width, self.size)
        momentView.backgroundColor = UIColor.whiteColor()
        momentView.layer.borderColor = UIColor.blackColor().CGColor!
        momentView.layer.borderWidth = 0.5
        self.scrollView.addSubview(momentView)
        self.momentsViews.insert(momentView, atIndex: Int(maximo2))
        
        returnX = newMomentX
        returnY = newMomentY
        returnWidth = self.width
        returnHeight = self.size
        
        var joinLine = JoinLine()
        joinLine.backgroundColor = UIColor.grayColor()
        joinLine.frame = CGRectMake(newLineX, newMomentY + size/2, lineWidth, 1)
        self.scrollView.addSubview(joinLine)
        self.lineTestArray.insert(joinLine,atIndex: Int(maximo2))
        
        var junction = Junction()
        junction.backgroundColor = UIColor.whiteColor()
        junction.frame = CGRectMake(xLine2-x1/3, newMomentY+size/2-x1/3, x1/1.5, x1/1.5)
        self.scrollView.addSubview(junction)
        self.junctionTestArray.insert(junction, atIndex: Int(maximo2))
        
        self.yArray.insert(junction.frame.origin.y, atIndex: Int(maximo2))
        
//        UIView.animateWithDuration(0.5, animations: {
//            
//            momentView.frame.origin.x = newMomentX
//            
//        })
//        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            momentView.frame.origin.x = newMomentX
            
            }) { (completedBool) -> Void in
                
                self.animation()
                
                NSNotificationCenter.defaultCenter().postNotificationName("PictureMoment", object: self)
        }
        
        self.max = Int(maximo2)
        
        for var k = 0; k < self.momentsViews.count; k++ {
            
            self.momentsViews[k].lastOrigin = self.momentsViews[k].frame.origin
            
        }
        
    }
    
     private func animation(){
        
        var frameExpansion = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: self.view.frame.height/2)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.pointJunction.frame.origin.x = -40
            
            for var j = 0; j < self.momentsViews.count; j++ {
                
                self.lineTestArray[j].frame.origin.x -= 2*self.momentsViews[j].frame.width
                self.junctionTestArray[j].frame.origin.x -= 2*self.momentsViews[j].frame.width
                
                if j != Int(self.max) {
                    self.momentsViews[j].frame.origin.x = -self.momentsViews[j].frame.width
                }
                    
                else {
                    
                    self.momentsViews[j].frame = frameExpansion
                    self.momentsViews[j].animate()
                }
                
            }
            
            self.dashed.frame.origin.x = -40
            
            }) { (completedBool) -> Void in
                
//                self.testMoment.frame = frameExpansion
//                self.testMoment.backgroundColor = UIColor.whiteColor()
//                self.view.addSubview(self.testMoment)
        }
    }
    
     func addEvent(recognizer: UITapGestureRecognizer) {
        
        var point = recognizer.locationInView(self.scrollView)
        
        var index = yArray.count - 1
        
        if point.y > yArray[0] && point.y < yArray[index] {
            
            self.organizeMoments(point.y)
            
        }
        
    }
    
     private func swap(first: Int) {
        
        var firstPoint = self.momentsViews[first].frame.origin
        
        if first > 0 && first < self.momentsViews.count-1 {
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.momentsViews[first].frame.origin = self.teste.lastOrigin
                self.teste.frame.origin = firstPoint
                
            })
        }
            
        else {
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.teste.frame.origin = self.teste.lastOrigin
                
            })
        }
    }
    
     private func changeOrder(first: Int, second: Int) {
        
        var aux = self.momentsViews[second]
        var yAux = self.yArray[second]
        var junctionAux = self.junctionTestArray[second]
        var lineAux = self.lineTestArray[second]
        
        if first > 0 && first < self.momentsViews.count - 1 {
            
            self.momentsViews[second] = self.momentsViews[first]
            self.momentsViews[first] = aux
            
        }
    }
    
     private func updateContentSize(sizeOfContent: CGFloat) {
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: sizeOfContent)
        
        dashed.removeFromSuperview()
        
        pointJunction.removeFromSuperview()
        
        dashed = DashedLine()
        dashed.backgroundColor = UIColor.clearColor()
        dashed.frame = CGRectMake(self.scrollView.bounds.size.width/2 - 22, 0, 44, self.scrollView.contentSize.height)
        dashed.addGestureRecognizer(tapEvent)
        self.scrollView.addSubview(dashed)
        self.scrollView.sendSubviewToBack(self.dashed)
        
        pointJunction = Junction()
        pointJunction.frame.size = CGSize(width: self.view.frame.width/20, height: self.view.frame.width/20)
        pointJunction.center = CGPoint(x: self.scrollView.frame.width/2, y: sizeOfContent)
        pointJunction.backgroundColor = UIColor.whiteColor()
        self.scrollView.addSubview(pointJunction)
        
    }
    
     private func substituteView(type: Int) {
        
        if type == 0
        {
            
            let imageView : UIImageView = self.momentsViews[self.max].contentView as! UIImageView
            imageView.image = self.image
            imageView.alpha = 0
            self.momentsViews[self.max].normalState(0)
            
            UIView.animateWithDuration(0.5, animations: {
                
                imageView.alpha = 1
                self.momentsViews[self.max].layer.borderWidth = 0
                self.pointJunction.center.x = self.scrollView.frame.width/2
                
                }, completion: {
                    (value : Bool) in
                    
                    UIView.animateWithDuration(0.5, animations: {
                        
                        self.dashed.frame.origin.x = self.view.frame.width/2 - 22
                        self.momentsViews[self.max].frame = CGRect(x: self.returnX, y: self.returnY, width: self.returnWidth, height: self.returnHeight)
                        self.momentsViews[self.max].contentView.frame.origin = CGPoint(x: 0, y: 0)
                        self.momentsViews[self.max].contentView.frame.size = CGSize(width: self.returnWidth, height: self.returnHeight)
                        
                        
                        for var i = 0; i < self.momentsViews.count; i++ {
                            
                            self.lineTestArray[i].frame.origin.x += 2*self.momentsViews[i].frame.width
                            self.junctionTestArray[i].frame.origin.x += 2*self.momentsViews[i].frame.width
                            
                            if i != self.max {
                                
                                self.momentsViews[i].frame.origin.x = self.momentsViews[i].lastOrigin.x
                                
                            }
                            
                        }
                        
                    })
            })
        }
        else if type == 1
        {
            (self.momentsViews[self.max].contentView as! UILabel).text = self.textLabel.text
            self.momentsViews[self.max].contentView.alpha = 0
            self.momentsViews[self.max].normalState(1)
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.momentsViews[self.max].contentView.alpha = 1
                self.momentsViews[self.max].layer.borderWidth = 0
                self.pointJunction.center.x = self.scrollView.frame.width/2
                
                }, completion: {
                    (value : Bool) in
                    
                    UIView.animateWithDuration(0.5, animations: {
                        
                        self.dashed.frame.origin.x = self.view.frame.width/2 - 22
                        self.momentsViews[self.max].frame = CGRect(x: self.returnX, y: self.returnY, width: self.returnWidth, height: self.returnHeight)
                        self.momentsViews[self.max].contentView.frame.size = CGSize(width: self.returnWidth, height: self.returnHeight)
                        
                        
                        for var i = 0; i < self.momentsViews.count; i++ {
                            
                            self.lineTestArray[i].frame.origin.x += 2*self.momentsViews[i].frame.width
                            self.junctionTestArray[i].frame.origin.x += 2*self.momentsViews[i].frame.width
                            
                            if i != self.max {
                                
                                self.momentsViews[i].frame.origin.x = self.momentsViews[i].lastOrigin.x
                                
                            }
                            
                        }
                        
                    })
            })
            
        }
    }
    
     private func addScrollView() {
     
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize = CGSizeMake(self.view.frame.width, totalHeight)
        scrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scrollView)
        
    }
    
     private func returnMax(max1: CGFloat, max2: CGFloat) -> CGFloat {
        
        var maximo1 = max1
        var maximo2 = max2
        
        if maximo1 > maximo2  {
            
            var aux = maximo2
            maximo2 = maximo1
            maximo1 = aux
        }
        
        return maximo2
     
    }
    
    
}