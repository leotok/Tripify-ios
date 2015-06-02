//
//  TimelineController.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TimelineController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tapEvent: UITapGestureRecognizer = UITapGestureRecognizer()
    var tapHoldEvent: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    var touchedPoint = CGFloat()
    
    var offset = CGFloat(20)
    var size = CGFloat(100)
    
    var momentsArray: [TestMoment] = [TestMoment]()
    
    var momentsTestArray: [TestMoment] = [TestMoment]()
    var lineTestArray: [UIView] = [UIView]()
    var junctionTestArray: [UIView] = [UIView]()
    
    var yArray: [CGFloat] = [CGFloat]()
    
    var scrollView: UIScrollView = UIScrollView()
    
    var newMoment: Bool = false
    var image: UIImage = UIImage()
    var point: CGPoint = CGPoint()
    
    var moved: Bool = false
    
    var firstPoint: CGPoint = CGPoint()
    
    
    var x1: CGFloat = CGFloat()
    var x2: CGFloat = CGFloat()
    var width: CGFloat = CGFloat()
    var xLine1: CGFloat = CGFloat()
    var xLine2: CGFloat = CGFloat()
    var y: CGFloat = CGFloat()
    var lineWidth: CGFloat = CGFloat()
    var count = Int(1)
    var bg = UIImageView()
    
    var totalHeight = CGFloat(0)
    
    var dashed: DashedLine = DashedLine()
    var pointJunction: Junction = Junction()
    
    var teste: TestMoment = TestMoment()
    
    var max = Int()
    
    var returnX = CGFloat(0)
    var returnY = CGFloat(0)
    var returnWidth = CGFloat(0)
    var returnHeight = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Trip"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"yourNotificationHandler:", name: "ModelViewDismiss", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"holdNotificationHandler:", name: "ViewHold", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"scrollNotification:", name: "ScrollNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"newPicture:", name: "PictureMoment", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        bg = UIImageView(frame: self.view.frame)
        bg.image = UIImage(named: "passport2.jpg")
        self.view.addSubview(bg)
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)
        
        //        Add ScrollView
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(self.view.frame.width, totalHeight)
        scrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(scrollView)
        
        
        //        Add DashedLine
        
        //        dashed = DashedLine()
        //        dashed.backgroundColor = UIColor.whiteColor()
        //        dashed.frame = CGRectMake(self.scrollView.bounds.size.width/2 - 1.25, 0, 10, 4500)
        //        self.scrollView.addSubview(dashed)
        
        
        //        Add TapEvent
        
        tapEvent = UITapGestureRecognizer(target: self, action:Selector("addEvent:"))
        tapHoldEvent = UILongPressGestureRecognizer(target: self, action: Selector("holdEvent:"))
        //        dashed.addGestureRecognizer(tapEvent)
        
        
        //        Add Moments
        
        x1 = 0.05 * self.view.bounds.width
        x2 = 0.55 * self.view.bounds.width
        width = 0.4 * self.view.bounds.width
        xLine1 = x1 + width
        xLine2 = self.view.bounds.width/2
        y = offset
        lineWidth = self.view.frame.size.width/2 - (x1 + width)
        
        //        var moments = momentsArray.count
        
        var moments = 2
        
        for var i = 0; i < moments; i++ {
            
            var height = CGFloat(0)
            
            if i%2 == 0 {
                
                var momentTest = TestMoment()
                momentTest.frame = CGRectMake(x1, y, width, size)
                momentTest.backgroundColor = UIColor.blackColor()
                self.scrollView.addSubview(momentTest)
                
                self.momentsTestArray.append(momentTest)
                
                var joinLine = JoinLine()
                joinLine.backgroundColor = UIColor.grayColor()
                joinLine.frame = CGRectMake(xLine1, y + size/2, lineWidth, 1)
                self.scrollView.addSubview(joinLine)
                self.lineTestArray.append(joinLine)
                
                var junction = Junction()
                junction.backgroundColor = UIColor.whiteColor()
                junction.frame = CGRectMake(xLine2-x1/3, y+size/2-x1/3, x1/1.5, x1/1.5)
                self.scrollView.addSubview(junction)
                self.junctionTestArray.append(junction)
                
                self.yArray.append(junction.frame.origin.y)
                
                height = momentTest.deltaY
            }
                
            else {
                
                var momentTest = TestMoment()
                momentTest.frame = CGRectMake(x2, y, width, size)
                momentTest.backgroundColor = UIColor.blackColor()
                self.scrollView.addSubview(momentTest)
                
                self.momentsTestArray.append(momentTest)
                
                var joinLine = JoinLine()
                joinLine.backgroundColor = UIColor.grayColor()
                joinLine.frame = CGRectMake(xLine2, y + size/2, lineWidth, 1)
                self.scrollView.addSubview(joinLine)
                self.lineTestArray.append(joinLine)
                
                var junction = Junction()
                junction.backgroundColor = UIColor.whiteColor()
                junction.frame = CGRectMake(xLine2-x1/3, y+size/2-x1/3, x1/1.5, x1/1.5)
                self.scrollView.addSubview(junction)
                self.junctionTestArray.append(junction)
                
                self.yArray.append(junction.frame.origin.y)
                
                height = momentTest.deltaY
                
            }
            
            //            totalHeight += size + offset
            
            //            y += size + offset
            
            totalHeight += height
            y += height
            
        }
        
        totalHeight += 100
        
        self.updateContentSize(totalHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func organizeMoments(createPoint: CGFloat) {
        
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
        
        if maximo > maximo2  {
            
            var aux = maximo2
            maximo2 = maximo
            maximo = aux
        }
        
        var newMomentY = self.momentsTestArray[Int(maximo2)].frame.origin.y
        var newMomentX = self.momentsTestArray[Int(maximo2)].frame.origin.x
        var newLineX = CGFloat(0)
        
        for var k = Int(maximo2); k < self.momentsTestArray.count; k++ {
            
            var x = self.momentsTestArray[k].frame.origin.x
            var y = self.momentsTestArray[k].frame.origin.y
            
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
                    self.momentsTestArray[k].frame.origin = CGPoint(x: newX, y: y + self.offset + self.size)
                    self.lineTestArray[k].frame.origin.y += self.offset + self.size
                    self.lineTestArray[k].frame.origin.x = lineX
                    self.junctionTestArray[k].frame.origin.y += self.offset + self.size
                })
            
            self.momentsTestArray[k].originalFrame = self.momentsTestArray[k].frame.origin
            
        }
        
        var momentTest = TestMoment()
        momentTest.frame = CGRectMake(self.view.bounds.width, newMomentY, self.width, self.size)
        momentTest.backgroundColor = UIColor.whiteColor()
        momentTest.layer.borderColor = UIColor.blackColor().CGColor!
        momentTest.layer.borderWidth = 0.5
        self.scrollView.addSubview(momentTest)
        self.momentsTestArray.insert(momentTest, atIndex: Int(maximo2))
        
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
        
        UIView.animateWithDuration(0.5, animations: {
            
            momentTest.frame.origin.x = newMomentX
            
        })
        
        self.max = Int(maximo2)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "animation", userInfo: nil, repeats: false)
        
    }
    
    func animation(){
        
        var frameExpansion = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: self.view.frame.height/2)
                
        UIView.animateWithDuration(0.5, animations: {
            
            self.pointJunction.frame.origin.x -= 2*self.view.frame.width
            
            for var j = 0; j < self.momentsTestArray.count; j++ {
                
                self.lineTestArray[j].frame.origin.x -= 2*self.momentsTestArray[j].frame.width
                self.junctionTestArray[j].frame.origin.x -= 2*self.momentsTestArray[j].frame.width
                
                if j != Int(self.max) {
                    self.momentsTestArray[j].frame.origin.x = -self.momentsTestArray[j].frame.width
                }
                    
                else {
                    
                    self.momentsTestArray[j].frame = frameExpansion
                    self.momentsTestArray[j].image.frame = frameExpansion
                    self.momentsTestArray[j].animate()
                    
                }
                
            }
            
            self.dashed.frame.origin.x = -40
            
            })
    }
    
    func yourNotificationHandler(notice: NSNotification) {
        
        self.image = notice.object as! UIImage
//        self.organizeMoments(self.point.y, image: self.image)
        
        self.substituteView()
        
    }
    
    func addEvent(recognizer: UITapGestureRecognizer) {
        
        self.point = recognizer.locationInView(self.scrollView)
        
        var index = yArray.count - 1
        
        if self.point.y > yArray[0] && self.point.y < yArray[index] {
            
            self.organizeMoments(point.y)
            
        }
        
    }
    
    func scrollNotification(notice: NSNotification) {
        
        var object = notice.object as! TestMoment
        
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
        
        self.teste = notice.object as! TestMoment
        self.moved = true
        var index = Int(0)
        var indexOriginal = Int(0)
        var center = CGPoint(x: self.teste.frame.midX, y: self.teste.frame.midY)
        
        
        for var i = 0; i < self.momentsTestArray.count; i++ {
            
            if CGRectContainsPoint(self.momentsTestArray[i].frame, center) && self.momentsTestArray[i].frame.origin != self.teste.frame.origin {
                
                index = i
                
            }
                
            else if CGRectContainsPoint(self.momentsTestArray[i].frame, center) && self.momentsTestArray[i].frame.origin == self.teste.frame.origin {
                
                indexOriginal = i
                
            }
            
        }
        
        swap(index)
        changeOrder(index, second: indexOriginal)
        
    }
    
    func swap(first: Int) {
        
        var firstPoint = self.momentsTestArray[first].frame.origin
        
        if first > 0 && first < self.momentsTestArray.count-1 {
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.momentsTestArray[first].frame.origin = self.teste.originalFrame
                self.teste.frame.origin = firstPoint
                
            })
        }
            
        else {
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.teste.frame.origin = self.teste.originalFrame
                
            })
        }
    }
    
    func changeOrder(first: Int, second: Int) {
        
        var aux = self.momentsTestArray[second]
        var yAux = self.yArray[second]
        var junctionAux = self.junctionTestArray[second]
        var lineAux = self.lineTestArray[second]
        
        if first > 0 && first < self.momentsTestArray.count - 1 {
            
            self.momentsTestArray[second] = self.momentsTestArray[first]
            self.momentsTestArray[first] = aux
            
        }
    }
    
    func updateContentSize(sizeOfContent: CGFloat) {
        
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
    
    func substituteView() {
        
        self.momentsTestArray[self.max].image.image = self.image
        self.momentsTestArray[self.max].image.alpha = 0
        self.momentsTestArray[self.max].normalState()
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.momentsTestArray[self.max].image.alpha = 1
            self.momentsTestArray[self.max].layer.borderWidth = 0
            self.pointJunction.frame.origin.x += 2*self.view.frame.width
            
            }, completion: {
                (value : Bool) in
                
                UIView.animateWithDuration(0.5, animations: {
                    
                    self.dashed.frame.origin.x = self.view.frame.width/2 - 22
                    self.momentsTestArray[self.max].frame = CGRect(x: self.returnX, y: self.returnY, width: self.returnWidth, height: self.returnHeight)
                    self.momentsTestArray[self.max].image.frame.origin = CGPoint(x: 0, y: 0)
                    self.momentsTestArray[self.max].image.frame.size = CGSize(width: self.returnWidth, height: self.returnHeight)
                    
                    
                    for var i = 0; i < self.momentsTestArray.count; i++ {
                        
                        self.lineTestArray[i].frame.origin.x += 2*self.momentsTestArray[i].frame.width
                        self.junctionTestArray[i].frame.origin.x += 2*self.momentsTestArray[i].frame.width
                        
                        if i != self.max {
                            
                            self.momentsTestArray[i].frame.origin.x = self.momentsTestArray[i].originalFrame.x
                            
                        }
                        
                    }
                    
                })
        })
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let selectedImage : UIImage = image
        self.image = selectedImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.substituteView()
        
    }
    
}

