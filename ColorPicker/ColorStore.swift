//
//  ColorStore.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/2/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit


class ColorStore {
    
    // create a dictionary to hold color values
    private var _colors = [String : UIColor]()
    private var _ccDict: [String: CGFloat] = ["hue" : 1.0, "sat" : 1.0, "bri" : 1.0, "alp" : 1.0]
    private var _pcDict: [String: CGFloat] = ["hue" : 1.0, "sat" : 1.0, "bri" : 1.0, "alp" : 1.0]
    
    // accessor properties
    var currentColor: UIColor
    {
        return UIColor(hue: _ccDict["hue"]!, saturation: _ccDict["sat"]!, brightness: _ccDict["bri"]!, alpha: _ccDict["alp"]!)
    }
    
    var previousColor: UIColor
    {
        return UIColor(hue: _pcDict["hue"]!, saturation: _pcDict["sat"]!, brightness: _pcDict["bri"]!, alpha: _pcDict["alp"]!)
    }

    
    // create a singleton computable property
    class var sharedInstance: ColorStore
    {
        
        struct Static {
            
            static var instance: ColorStore?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
        
            let currentColor = UIColor(hue: 0.9, saturation: 1, brightness: 1, alpha: 1)
            let previousColor = UIColor(hue: 0.8, saturation: 1, brightness: 1, alpha: 1)
            
            Static.instance = ColorStore(currentColor: currentColor, previousColor: previousColor)
        }

        return Static.instance!
    }
    
    init(currentColor: UIColor, previousColor: UIColor)
    {
        _colors["currentColor"] = currentColor
        _colors["previousColor"] = previousColor
    }
    
    // update colors
    func updateColorsWith(property: HSBA, itsValue value: CGFloat, isCurrentColor currentColor: Bool)
    {
        if currentColor {
            _ccDict[property.stringName] = value

        } else {
            _pcDict[property.stringName] = value
        }
        
    }
    
    func getColorValuesOf(currentSwatch: Bool) -> [String : CGFloat]
    {
        if currentSwatch {
            return _ccDict
        } else {
            return _pcDict
        }
    }

    
}
