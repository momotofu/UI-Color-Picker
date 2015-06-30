//
//  Swatch.swift
//  ColorPicker
//
//  Created by Christopher REECE on 2/7/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class Checker: UIView {
    
    var color: UIColor = UIColor.whiteColor()
    let evenColor = UIColor.lightGrayColor()
    let oddColor = UIColor.whiteColor()
    var switcher: Bool = true

        

    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = min(bounds.width, bounds.height)
        let height = max(bounds.width, bounds.height)
        let checkerWidth: CGFloat = width / 10
        
        for i in 0...9 {
            
            var view = UIView(frame: CGRectMake(CGFloat(i) * checkerWidth, 0, checkerWidth, checkerWidth))
            
            if switcher {
                view.backgroundColor = evenColor
                switcher = false
            } else {
                view.backgroundColor = oddColor
                switcher = true
            }
            
            addSubview(view)
            
            for j in 0...9 {
                
                var view = UIView(frame: CGRectMake(CGFloat(i) * checkerWidth, CGFloat(j) * checkerWidth, checkerWidth, checkerWidth))
                
                if switcher {
                    view.backgroundColor = evenColor
                    switcher = false
                } else {
                    view.backgroundColor = oddColor
                    switcher = true
                }
                
                addSubview(view)
                
            }
        }
        
    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}