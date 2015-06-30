//
//  Swatches.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/3/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

// declare swatch protocol
protocol SwatchesDelegate: class {
    
    var currentIsSelected: Bool {get set}
    func refresh()

}

class Swatches: UIView {
    
    private var _currentColor: UIView!
    private var _previousColor: UIView!
    let colorStore = ColorStore.sharedInstance
    weak var Delegate:SwatchesDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let checker = Checker(frame: CGRectMake(0, 0, bounds.width, bounds.height))
        self.addSubview(checker)
        
        _currentColor = UIView()
        _currentColor.backgroundColor = ColorStore.sharedInstance.currentColor
        _currentColor.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(_currentColor)
        
        _previousColor = UIView()
        _previousColor.backgroundColor = ColorStore.sharedInstance.currentColor
        _previousColor.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(_previousColor)
        
    
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // function to update colors
    func updateColors()
    {
        _currentColor.backgroundColor = ColorStore.sharedInstance.currentColor
        _previousColor.backgroundColor = ColorStore.sharedInstance.previousColor
    }
    
    override func layoutSubviews()
    {
        var r: CGRect = bounds
        (_previousColor.frame, r) = r.rectsByDividing(r.width / 2.0, fromEdge: CGRectEdge.MinXEdge)
        _currentColor.frame = r
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            Delegate?.refresh()
            
            if CGRectContainsPoint(subviews[1].frame, touch.locationInView(self)) {
                println("view 0 touched")
                Delegate?.currentIsSelected = true
            } else {
                println("view 1 touched")
                Delegate?.currentIsSelected = false
            }
        }
    }

}