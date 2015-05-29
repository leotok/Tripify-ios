//
//  TimelineController.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TimelineController: UIViewController, UIScrollViewDelegate {
    
    var tapEvent: UITapGestureRecognizer = UITapGestureRecognizer()
    var tapHoldEvent: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    var touchedPoint = CGFloat()
    
    var offset = CGFloat(20)
    var size = CGFloat(100)
    
    var momentsArray: [TestMoment] = [TestMoment]()
    
    var momentsTestArray: [UIView] = [UIView]()
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
    
    var totalHeight = CGFloat(0)
    
    var dashed: DashedLine = DashedLine()
    
    var teste: TestMoment = TestMoment()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Trip"
        self.view.backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"yourNotificationHandler:", name: "ModelViewDismiss", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"holdNotificationHandler:", name: "ViewHold", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"scrollNotification:", name: "ScrollNotification", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        Add ScrollView
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(self.view.frame.width, totalHeight)
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
                joinLine.backgroundColor = UIColor.redColor()
                joinLine.frame = CGRectMake(xLine1, y + size/2, lineWidth, 2)
                self.scrollView.addSubview(joinLine)
                self.lineTestArray.append(joinLine)
                
                var junction = Junction()
                junction.backgroundColor = UIColor.blueColor()
                junction.frame = CGRectMake(xLine2-x1/2, y+size/2-x1/2, x1, x1)
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
                joinLine.backgroundColor = UIColor.redColor()
                joinLine.frame = CGRectMake(xLine2, y + size/2, lineWidth, 2)
                self.scrollView.addSubview(joinLine)
                self.lineTestArray.append(joinLine)
                
                var junction = Junction()
                junction.backgroundColor = UIColor.blueColor()
                junction.frame = CGRectMake(xLine2-x1/2, y+size/2-x1/2, x1, x1)
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
        
        totalHeight += 47
        
        self.updateContentSize(totalHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func organizeMoments(createPoint: CGFloat, image: UIImage) {
        
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
            
            UIView.animateWithDuration(0.2, animations: {
                
                self.momentsTestArray[k].frame.origin = CGPoint(x: newX, y: y + self.offset + self.size)
                self.lineTestArray[k].frame.origin.y += self.offset + self.size
                self.lineTestArray[k].frame.origin.x = lineX
                self.junctionTestArray[k].frame.origin.y += self.offset + self.size
                
            })
            
        }
        
        var momentTest = TestMoment()
        momentTest.frame = CGRectMake(self.view.bounds.width, newMomentY, self.width, self.size)
        momentTest.backgroundColor = UIColor.redColor()
//        momentTest.image = self.image
        self.scrollView.addSubview(momentTest)
        self.momentsTestArray.insert(momentTest, atIndex: Int(maximo2))
        
        var joinLine = JoinLine()
        joinLine.backgroundColor = UIColor.redColor()
        joinLine.frame = CGRectMake(newLineX, newMomentY + size/2, lineWidth, 2)
        self.scrollView.addSubview(joinLine)
        self.lineTestArray.insert(joinLine,atIndex: Int(maximo2))

        var junction = Junction()
        junction.backgroundColor = UIColor.blueColor()
        junction.frame = CGRectMake(xLine2-x1/2, newMomentY+size/2-x1/2, x1, x1)
        self.scrollView.addSubview(junction)
        self.junctionTestArray.insert(junction, atIndex: Int(maximo2))
        
        self.yArray.insert(junction.frame.origin.y, atIndex: Int(maximo2))
        
        totalHeight += self.size + self.offset
        self.updateContentSize(totalHeight)
        
        UIView.animateWithDuration(0.2, animations: {
            
            momentTest.frame.origin.x = newMomentX
            
        })
        
    }
    
    func yourNotificationHandler(notice: NSNotification) {
        
        self.image = notice.object as! UIImage
        self.organizeMoments(self.point.y, image: self.image)
        
    }
    
    func addEvent(recognizer: UITapGestureRecognizer) {
        
        self.point = recognizer.locationInView(self.scrollView)
        
        var index = yArray.count - 1
        
        if self.point.y > yArray[0] && self.point.y < yArray[index] {
            
            self.organizeMoments(point.y, image: self.image)
            
//            var imagePicker = NewMomentController()
            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
        
        }
       
    }
    
    func scrollNotification(notice: NSNotification) {
        
        var object = notice.object as! TestMoment
        
        var visibleRect = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y + self.scrollView.bounds.size.height)
        
        var min = self.view.bounds.height + self.scrollView.contentOffset.y
        
        println(totalHeight)
        println(visibleRect.height)
        
        if object.frame.origin.y > 0.9 * visibleRect.size.height && visibleRect.height < self.totalHeight{

            self.scrollView.contentOffset.y += 15
            
        }
        
        else if object.frame.origin.y < self.scrollView.contentOffset.y + 20 && self.scrollView.contentOffset.y > 0 {
            
            self.scrollView.contentOffset.y -= 15
            
        }
        
    }
    
    
    func holdNotificationHandler(notice: NSNotification) {
        
        self.teste = notice.object as! TestMoment
        self.moved = true
        var index = Int(0)
        var indexOriginal = Int(0)
        
        for var i = 0; i < self.momentsTestArray.count; i++ {
            
            if CGRectContainsPoint(self.momentsTestArray[i].frame, teste.frame.origin) && self.momentsTestArray[i].frame.origin != self.teste.frame.origin {
                
                index = i

            }
            
            else if CGRectContainsPoint(self.momentsTestArray[i].frame, teste.frame.origin) && self.momentsTestArray[i].frame.origin == self.teste.frame.origin {
                
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
        
        dashed = DashedLine()
        dashed.backgroundColor = UIColor.whiteColor()
        dashed.frame = CGRectMake(self.scrollView.bounds.size.width/2 - 1.25, 0, 10, self.scrollView.contentSize.height)
        dashed.addGestureRecognizer(tapEvent)
        self.scrollView.addSubview(dashed)
        self.scrollView.sendSubviewToBack(self.dashed)
        
    }
    
    
}

