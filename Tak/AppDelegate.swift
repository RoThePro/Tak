//
//  AppDelegate.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/6/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.grayColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        Parse.setApplicationId("mZNskormslX8gEY3A5f9gnPytjw2BbHZ4tdtFXSC", clientKey: "AZN6tPrNwZwgV4HAkGmF8JvlbPyZBF6TQ2QZNO3w")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFTwitterUtils.initializeWithConsumerKey("juc1RZgyQdtUqJr2KZS1xmKtV",  consumerSecret:"YIHdlHfFEAGCLByk5coVT5c21ZsCTryXz1nSGiriTDZvBJ63vn")
        /**
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        **/
        
        return true
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
  
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()

    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

