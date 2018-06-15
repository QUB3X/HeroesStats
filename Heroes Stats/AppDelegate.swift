//
//  AppDelegate.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Setup Split View Controller
        guard
            let rootVC = window?.rootViewController as? UITabBarController,
            let splitVC = rootVC.viewControllers?[1] as? UISplitViewController,
            let masterNC = splitVC.viewControllers.first as? UINavigationController,
            let detailNC = splitVC.viewControllers.last as? UINavigationController,
            let masterVC = masterNC.topViewController as? HeroListVC,
            let detailVC = detailNC.topViewController as? HeroDetailVC
        else {
            fatalError()
        }
        
        let firstHero = masterVC.heroes.first
        detailVC.hero = firstHero
        
        masterVC.delegate = detailVC
        
        // Setup dropdown
        DropDown.startListeningToKeyboard()

        // Set ui color
        // UIButton.appearance().tintColor = UIColor.Accent.Purple.dark
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
