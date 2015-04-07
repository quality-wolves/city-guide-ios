//
//  AppDelegate.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    var mainVC: MainViewController!
	
    class func sharedInstance() -> AppDelegate {
        return  UIApplication.sharedApplication().delegate as AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //check if this is a first launch.
        //if database file exists in documents, then we was here already. Nothing todo here
        if (!NSFileManager.defaultManager().fileExistsAtPath(SQLiteWrapper.sharedInstance().databasePath())) {
            SQLiteWrapper.sharedInstance().checkFile()
            var path: NSString = NSBundle.mainBundle().pathForResource("thumbnails.zip", ofType: nil)!
            println(path)
            if let thumbnailsUrl = NSURL(fileURLWithPath: path) {
                DataManager.instance().downloadAndUnzip(thumbnailsUrl.absoluteString, completionHandler: {
                    NSLog("Update complete!")
                })
            }
        }
		
		DataManager.instance();
		
        mainVC = MainViewController()
        SQLiteWrapper.sharedInstance().checkFile()
        SQLiteWrapper.sharedInstance().openDatabase()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        navigationController = UINavigationController(rootViewController: mainVC)
        navigationController?.navigationBarHidden = true;
        window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}