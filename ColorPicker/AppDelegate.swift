//
//  AppDelegate.swift
//  ColorPicker
//
//  Created by Christopher REECE on 1/30/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        let rect = CGRectMake(window!.center.x, window!.center.y, 200, 200)
        let hueWheel = HueWheel(frame: CGRectMake(rect.origin.x - rect.width / 2, rect.origin.y - rect.height / 2, rect.width, rect.height))
 //       hueWheel.backgroundColor = UIColor.redColor()
    
        let stateSwitcher = StateSwitcher(frame: CGRectMake(0, 0, 200, 20))
        stateSwitcher.center.x = hueWheel.center.x
        stateSwitcher.center.y = hueWheel.center.y + hueWheel.frame.height / 1.3
        stateSwitcher.Delegate = hueWheel
        
        let colorStore = ColorStore.sharedInstance

        
//        hueWheel.backgroundColor = UIColor.redColor()
 
        window?.addSubview(hueWheel)
        window?.addSubview(stateSwitcher)
        
        return true
    }




}

