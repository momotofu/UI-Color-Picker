//
//  StateSwitcher.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/4/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

// declare swatch protocol
protocol StateSwitcherDelegate: class {
    
    var state: HSBA {get set}
    
}

class StateSwitcher: UIView {
    
    private var _state: HSBA = .hue
    private let _nib: Shape!
    private var _nibClosestSlot: Shape?
    weak private var _timer: NSTimer?
    weak var Delegate:StateSwitcherDelegate?
    
    
    // drawing properties
    let width: CGFloat!
    let height: CGFloat!
    let circleSize: CGFloat!
    
    // declare x axis variables
    let hueX: CGFloat!
    let satX: CGFloat!
    let briX: CGFloat!
    let alpX: CGFloat!
    
    
    override func drawRect(rect: CGRect) {

        
        let context: CGContext = UIGraphicsGetCurrentContext()
        
        // background drawing
        if width > height {
            // draw path for sliders
            CGContextMoveToPoint(context, height / 4, height / 4 + 2)
            CGContextAddLineToPoint(context, width - (height / 4) + 1, height / 4 + 2)
            CGContextAddLineToPoint(context, width - (height / 4) + 1, height - (height / 4) - 1)
            CGContextAddLineToPoint(context, height / 4, height - (height / 4) - 1)
            CGContextClosePath(context)
            
            CGContextSetFillColorWithColor(context, UIColor.darkGrayColor().CGColor)
        
            CGContextDrawPath(context, kCGPathFill)
        } else  {
            
            // draw path for sliders
            CGContextMoveToPoint(context, width / 4, width / 4)
            CGContextAddLineToPoint(context, height - (width / 4), width / 4)
            CGContextAddLineToPoint(context, height - (width / 4), width - (width / 4))
            CGContextAddLineToPoint(context, width / 4, width - (width / 4))
            CGContextClosePath(context)
            
            CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor)

            CGContextDrawPath(context, kCGPathFill)
        }
        

    }
    
    override init(frame: CGRect) {
        
        // drawing properties
        width = max(frame.width, frame.height)
        height = min(frame.width, frame.height) 
        circleSize = height! * 0.95
        
        // declare x axis variables
        hueX = 0
        satX = width! / 4 + circleSize! / 2
        briX = width! / 2 + circleSize!
        alpX = width! - height!
        
        let nobSize = circleSize * 0.7
        
        let slotPoints = [hueX, satX, briX, alpX]
        
        
        // create a nob
        let nibFrame = CGRectMake(0, 0, height, height)
        let nibColor = UIColor(white: 1, alpha: 0.9)
        _nib = Shape(frame: nibFrame, setColor: nibColor, shape: .circle, multiplier: 0.6, state: HSBA(rawValue: 1)!)
        super.init(frame: frame)
        
        // create slots
        for i in 0...3 {
            
            let frame = CGRectMake(slotPoints[i], 0, height, height)
            let slotColor = UIColor.darkGrayColor()
            let hueSlot: Shape = Shape(frame: frame, setColor: slotColor, shape: .circle, multiplier: 1, state: HSBA(rawValue: i + 1)!)
            
            addSubview(hueSlot)
        }
      
        addSubview(_nib)

        backgroundColor = UIColor.clearColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            let touchPoint = touch.locationInView(self)
            for view in subviews {
                
                if CGRectContainsPoint(view.frame, touchPoint) {
                    
                    _nib!.shapeState = (view as! Shape).shapeState
                    
                    println("shape: \(_nib.shapeState.rawValue)")
                }
            }
            _nib!.center.x = touchPoint.x
            pointLimitations(_nib!, comparingPoint: touchPoint)
            
            Delegate?.state = _nib.shapeState
        }
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            let touchPoint = touch.locationInView(self)
            
            for view in subviews {
                
                if CGRectContainsPoint(view.frame, touchPoint) {
                    
                    _nib!.shapeState = (view as! Shape).shapeState
                    
                }
            }
            _nib!.center.x = touchPoint.x
            pointLimitations(_nib!, comparingPoint: touchPoint)
            
            Delegate?.state = _nib.shapeState
        }
    }

    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            let touchPoint = touch.locationInView(self)
            
            for view in subviews {
                
                
                if _nibClosestSlot == nil {
                    checkDistanceBetween(_nib, and: (view as! Shape))
                }
            }
        }
    }
    
    func pointLimitations(shape: Shape?, comparingPoint: CGPoint)
    {
        if shape!.center.x >= width - height {
            
            shape!.frame.origin.x = width - height
        } else if shape!.center.x < 0 {
            shape!.frame.origin.x = 0
        }
    }
    
    func checkDistanceBetween(nib: Shape?, and slot:Shape)
    {
       
        let xDif = nib!.center.x - slot.center.x
        let distance = abs(xDif)

        if distance <= width / 6 {
            
             _nibClosestSlot = slot
            let myRunLoop = NSRunLoop.currentRunLoop()
                
            let animationTimer = NSTimer(timeInterval: 0.025, target: self, selector: "gravitate:", userInfo: nil, repeats: true)

            myRunLoop.addTimer(animationTimer, forMode: NSDefaultRunLoopMode)
            println("timer should have fired")
        }
    }
    
    func gravitate(timer: NSTimer)
    {

       // if _nib!.center.x != _nibClosestSlot!.center.x {
       // if _nib!.center.x != _nibClosestSlot!.center.x {
            // get quadrant of _nib
        let nib = _nib!.center
        let neb = _nibClosestSlot!.center
        var angle = atan2f(Float(nib.y - neb.y), Float(nib.x - neb.x))
        let gravity = CGFloat(Forces.gravity)
        
            _nib!.center.x += CGFloat(cosf(angle) * -1) * gravity
            Forces.gravity *= 1.05
        
        let nibPoint = CGPointMake(_nib!.center.x, _nib!.center.y)
        
        if CGRectContainsPoint(_nibClosestSlot!.frame, nibPoint) {
            _nib!.center = neb
            _nib!.shapeState = _nibClosestSlot!.shapeState
            Delegate?.state = _nib.shapeState
            timer.invalidate()
            _nibClosestSlot = nil
            Forces.gravity = 1.0
        }
        
      //  }
        println("gravitate fired")
        
    }
    
    struct Forces
    {
        static private var _gravity: Float = 1.0
        static var gravity: Float {
            get {
            return _gravity
            } set {
                _gravity = newValue
            }
        }
    }
    
}





























