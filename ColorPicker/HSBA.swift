//
//  HSBA.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/3/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import Foundation


// declare HSBA string enum
enum HSBA: Int
{
    case hue = 1, sat, bri, alp
    
    var stringName: String {
        let stringName = [
            "hue",
            "sat",
            "bri",
            "alp"]
        
        return stringName[rawValue - 1]
    }
}