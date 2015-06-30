//
//  HueWheel.swift
//  ColorPicker
//
//  Created by Christopher REECE on 1/30/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class HueWheel: UIView, SwatchesDelegate, StateSwitcherDelegate
{
    
    // class properties
    private var _angle: Float = (2.0 * Float(M_PI) * 0.248) * -1
    private var _knobRect: CGRect = CGRectZero
    private var _radius: CGFloat!
    private var _size: CGSize?
    private var _center: CGPoint?
    private var _swatches: Swatches?
    private var _nib: Shape?
    private var _state: HSBA = .hue
    private var _CS = ColorStore.sharedInstance
    
    var state: HSBA {
        get {
            return _state
        }
        set {
            _state =  newValue
            setNeedsDisplay()
        }
    }
    
    var currentIsSelected: Bool = false
    
    let sectors = CGFloat(1080)
    var angle: CGFloat {
        return  2 * CGFloat(M_PI) / CGFloat(sectors)
    }

    
    var nibAngle: Float
    {
        get {return _angle}
        set {
            _angle = newValue

        }
    }
    
    func refresh()
    {
        setNeedsDisplay()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        // initialize class properties
        _center = CGPointMake(self.bounds.midX, self.bounds.midY)
        _radius = bounds.width / 2.1
        backgroundColor = UIColor.clearColor()
        let knobColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        let knobRadius = _radius * 1.73
        let knobCenter = Shape(frame: CGRectMake(_center!.x - (knobRadius) / 2, _center!.y - (knobRadius) / 2, knobRadius, knobRadius), setColor: knobColor, shape: .circle)
        
        _nib = Shape(frame: CGRectMake(_center!.x - bounds.width, _center!.y - bounds.height, bounds.width / 6.5, bounds.height / 6.5), setColor: UIColor.darkGrayColor(), shape: .triangle)
        _nib!.center.x = bounds.midX
        _nib!.center.y = bounds.midY - _radius * 1.101
        let multiplier: Float = 0.1
        _nib!.rotation = CGFloat(nibAngle)

        // add color swatches
         _swatches = Swatches(frame: CGRectMake(bounds.midX - frame.size.width / 6, bounds.midY - frame.size.height / 6, frame.size.width / 3, frame.size.height / 3))
         _swatches?.Delegate = self

        self.addSubview(knobCenter)
        self.addSubview(_swatches!)
        self.addSubview(_nib!)
      
    }
    
    override func drawRect(rect: CGRect)
    {
        checkerGradient()
        
        switch _state {
        case .hue:
            hueGradient()
        case .sat:
            satGradient()
        case .bri:
            briGradient()
        case .alp:
            alpGradient()
        default:
            hueGradient()
        }
        
    }
    
    func drawRadialGradient() -> UIImage
    {
        var colorPath: UIBezierPath?
        
        UIGraphicsBeginImageContext(CGSizeMake(bounds.size.width, bounds.size.height))
        
        for var i:CGFloat = 0; i < sectors; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * angle, endAngle:(i + 1) * angle, clockwise: true)
            
            colorPath?.lineCapStyle = kCGLineCapRound
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            var currentColor = UIColor(hue: i / sectors, saturation: 1.0, brightness: 1.0, alpha: 1)
            currentColor.setStroke()
            currentColor.setFill()
            
            colorPath?.stroke()
            
        }
        
        
        drawOutline()
        
        
        let backgroundImg = UIGraphicsGetImageFromCurrentImageContext()
        
        return backgroundImg
    }
    
    func checkerGradient()
    {
        var colorPath: UIBezierPath?
        let checkerAngle = 2 * CGFloat(M_PI) / 120
        
        for var i:CGFloat = 0; i < 120; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * checkerAngle, endAngle:(i + 1) * checkerAngle, clockwise: true)

            colorPath?.lineCapStyle = kCGLineCapRound
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            if i % 2 == 0 {
                var currentColor = UIColor(hue: 1.0, saturation: 0.1, brightness: 0.7, alpha: 1.0)
                currentColor.setStroke()
                currentColor.setFill()
                
                colorPath?.stroke()
                colorPath?.fill()
            } else {
                var currentColor = UIColor(hue: 1.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
                currentColor.setStroke()
                currentColor.setFill()
                
                colorPath?.stroke()
                colorPath?.fill()
            }

            
        }
        
        
        drawOutline()
    }

    
    func hueGradient()
    {
        let CV = _CS.getColorValuesOf(currentIsSelected)
        var colorPath: UIBezierPath?
        
        for var i:CGFloat = 0; i < sectors; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * angle, endAngle:(i + 1) * angle, clockwise: true)
            
            
            colorPath?.lineCapStyle = kCGLineCapRound
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            var currentColor = UIColor(hue: i / sectors, saturation: CV["sat"]!, brightness: CV["bri"]!, alpha: CV["alp"]!)
            currentColor.setStroke()
            currentColor.setFill()
            
            colorPath?.stroke()
            
        }
        
        
        drawOutline()
    }
    
    func satGradient()
    {
        let CV = _CS.getColorValuesOf(currentIsSelected)
        var colorPath: UIBezierPath?
        
        for var i:CGFloat = 0; i < sectors; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * angle, endAngle:(i + 1) * angle, clockwise: true)
            
            
            colorPath?.lineCapStyle = kCGLineCapButt
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            var currentColor = UIColor(hue: CV["hue"]! , saturation: i / sectors, brightness: CV["bri"]!, alpha: CV["alp"]!)
            currentColor.setStroke()
            currentColor.setFill()
            
            colorPath?.stroke()
            
        }
        
        
        drawOutline()
    }
    
    func briGradient() {
        let CV = _CS.getColorValuesOf(currentIsSelected)
        var colorPath: UIBezierPath?
        
        for var i:CGFloat = 0; i < sectors; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * angle, endAngle:(i + 1) * angle, clockwise: true)
            
            colorPath?.lineCapStyle = kCGLineCapButt
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            var currentColor = UIColor(hue: CV["hue"]! , saturation: CV["sat"]!, brightness: i / sectors, alpha: CV["alp"]!)
            currentColor.setStroke()
            currentColor.setFill()
            
            colorPath?.stroke()
            
        }
        
        drawOutline()
    }

    func alpGradient()
    {
        let CV = _CS.getColorValuesOf(currentIsSelected)
        var colorPath: UIBezierPath?
        var outLinePath: UIBezierPath?
        
        for var i:CGFloat = 0; i < sectors; i++
        {
            colorPath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle:i * angle, endAngle:(i + 1) * angle, clockwise: true)
            
            
            colorPath?.lineCapStyle = kCGLineCapButt
            colorPath?.addLineToPoint(_center!)
            colorPath?.closePath()
            
            var currentColor = UIColor(hue: CV["hue"]!, saturation: CV["sat"]!, brightness: CV["bri"]!, alpha: i / sectors)
            currentColor.setStroke()
            currentColor.setFill()
            
            colorPath?.stroke()
            
        }
        
        drawOutline()

    }
    
    func drawOutline()
    {
        var outLinePath = UIBezierPath(arcCenter: _center!, radius: _radius, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        outLinePath.lineWidth = _radius * 0.035
        
        var currentColor = UIColor.darkGrayColor()
        currentColor.setStroke()
        outLinePath.stroke()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    // UIResponder Methods
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            let touchPoint: CGPoint = touch.locationInView(self)
            let touchAngle: Float = atan2f(Float(touchPoint.y - _center!.y), Float(touchPoint.x - _center!.x))
            
            //          let touchAngle: Float = atan2f(Float(touchPoint.y - _center!.y), Float(touchPoint.x - _center!.x))
            
            nibAngle = touchAngle
            
            var degrees = CGFloat((nibAngle * 180)) / CGFloat(M_PI)
            let inverseDegrees = degrees
            // println("touchAngle: \(inverseDegrees + 180)")
            
            // Convert to a value from 0 to 1. TwoPie = 1.
            var nibValue: CGFloat = 0.0
            let TwoPie = Float(2 * M_PI)
            let newPie = CGFloat(M_PI - 3.14159)
            let multiplier: CGFloat = 1.101
            
            var tx = (_radius * multiplier) * CGFloat(cosf(Float(nibAngle)))
            var ty = (_radius * multiplier) * CGFloat(sinf(Float(nibAngle))) + _radius * 1.101
            
            println("tx: \(tx)")
            println("ty: \(ty)")
            
            let context = UIGraphicsGetCurrentContext()
            // println("\(nibAngle)")
            //  println("\(M_PI)")
            if nibAngle >= 0 {
                // println("touchAngle in Radians: \(nibAngle / TwoPie)")
                nibValue = CGFloat(nibAngle / TwoPie)
                
                let rotation = CGFloat(nibAngle) + newPie
                // println("\(rotation)")
                
                var transform = CGAffineTransformMakeTranslation(tx, ty)
                _nib!.transform = transform
                _nib!.rotation = rotation
                _nib!.setNeedsDisplay()
                
            } else {
                // println("TouchAngle in Radians: \(abs(nibAngle + TwoPie) / TwoPie)")
                nibValue = CGFloat(abs(nibAngle + TwoPie) / TwoPie)
                
                let rotation = CGFloat(abs(nibAngle + TwoPie)) + (newPie * 2)
                // println("\(rotation)")
                
                var  transform = CGAffineTransformMakeTranslation(tx, ty)
                _nib!.transform = transform
                _nib!.rotation = rotation
                _nib!.setNeedsDisplay()
            }
            
            ColorStore.sharedInstance.updateColorsWith(state, itsValue: nibValue, isCurrentColor: currentIsSelected)
            //        println("currentValue\(currentIsSelected)")
            _swatches?.updateColors()
        }
    }
    
 
}

