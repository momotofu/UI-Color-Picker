//
//  Nib.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/4/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

// Equatable protocol
func ==(lhs: Shape, rhs: Shape) -> Bool
{
    return lhs == rhs
}

class Shape: UIView, Equatable {
    
    private var _rotation: CGFloat = 0.0
    private var _multiplier: CGFloat = 1
    private var _state: HSBA = .hue
    
    var shapeState: HSBA {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }

    var rotation: CGFloat {
        get {
            return _rotation
        }
        set {
            _rotation = newValue + (2 * CGFloat(M_PI) * 0.248)
        }
    }
    var nibCenter: CGPoint = CGPointMake(0, 0)
    var color: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
    private var _shape: Shapes = Shapes.circle
    
    override func drawRect(rect: CGRect)
    {
        let context: CGContext = UIGraphicsGetCurrentContext()
        
        let width = min(bounds.size.width, bounds.size.height) * 0.6
        
        switch _shape {
        case .circle:
            let nib = UIBezierPath(arcCenter: nibCenter, radius: CGFloat(min(bounds.width, bounds.height) * _multiplier) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
            color.setFill()
            nib.fill()
            
        case .triangle:
            CGContextTranslateCTM(context, bounds.midX, bounds.midY) ;
            println("width: \(width)")
            CGContextRotateCTM(context,
                rotation)
            CGContextMoveToPoint(context, 0, (width / 2) * -1)
            CGContextAddLineToPoint(context, width / 2, width / 2)
            CGContextAddLineToPoint(context, (width / 2) * -1, width / 2)
            CGContextClosePath(context)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextDrawPath(context, kCGPathFill)

            
        case .square:
            let nib = UIBezierPath(arcCenter: nibCenter, radius: CGFloat(min(bounds.width, bounds.height)) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
            color.setFill()
            nib.fill()
            
        case .pentagon:
            let nib = UIBezierPath(arcCenter: nibCenter, radius: CGFloat(min(bounds.width, bounds.height)) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
            color.setFill()
            nib.fill()
            
        case .hexagon:
            let nib = UIBezierPath(arcCenter: nibCenter, radius: CGFloat(min(bounds.width, bounds.height)) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
            color.setFill()
            nib.fill()
    
        default:
            let nib = UIBezierPath(arcCenter: nibCenter, radius: CGFloat(min(bounds.width, bounds.height)) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
            color.setFill()
            nib.fill()
        }
    }
    
    init(frame: CGRect, setColor: UIColor?, shape: Shapes)
    {
        super.init(frame: frame)
        
        _shape = shape
        if setColor != nil { color = setColor! }
        self.backgroundColor = UIColor.clearColor()
        nibCenter = CGPointMake(bounds.midX, bounds.midY)
    }
    
    init(frame: CGRect, setColor: UIColor?, shape: Shapes, multiplier: CGFloat)
    {
        super.init(frame: frame)
        
        _multiplier = multiplier
        _shape = shape
        if setColor != nil { color = setColor! }
        self.backgroundColor = UIColor.clearColor()
        nibCenter = CGPointMake(bounds.midX, bounds.midY)
    }
    
    init(frame: CGRect, setColor: UIColor?, shape: Shapes, multiplier: CGFloat, state: HSBA)
    {
        super.init(frame: frame)
        
        _state = state
        _multiplier = multiplier
        _shape = shape
        if setColor != nil { color = setColor! }
        self.backgroundColor = UIColor.clearColor()
        nibCenter = CGPointMake(bounds.midX, bounds.midY)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        nibCenter = CGPointMake(bounds.midX, bounds.midY)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
