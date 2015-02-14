//
//  AppDelegate.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var mainVC: MainViewController!
    var hotspotsController: HotspotCollectionViewController!
    
    internal var transitionController: HATransitionController?
    
    class func sharedInstance() -> AppDelegate {
        return  UIApplication.sharedApplication().delegate as AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        mainVC = MainViewController()
        hotspotsController = HotspotCollectionViewController()
        println(hotspotsController.view.description)
        transitionController = HATransitionController(collectionView: hotspotsController.collectionView)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        navigationController = UINavigationController(rootViewController: mainVC)
        navigationController?.navigationBarHidden = true;
        navigationController?.delegate = self;
        window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (transitionController === animationController) {
            
            return self.transitionController
        }
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if !fromVC.isKindOfClass(UICollectionViewController) || !toVC.isKindOfClass(UICollectionViewController) {
            return nil
        }
//        if let frm = fromVC as? UICollectionViewController {
//            if let tvc = toVC as? UICollectionViewController {
//                self.transitionController?.navigationOperation = operation
//                return self.transitionController
//            }
//        }
        
        if (self.transitionController?.hasActiveInteraction != nil) {
            return nil
        }
        
        self.transitionController?.navigationOperation = operation
        return self.transitionController

//        return nil
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

