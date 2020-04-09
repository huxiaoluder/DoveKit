//
// AppDelegate.swift
// DoveKit_Example 
// 
// Created by xiaoming on 2018/10/13.
// Copyright © 2018 CocoaPods. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit
import DoveKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarVC = UITabBarController(useDove: true, base: .currentAnimation)
        
        let transitionVC = TableViewController()
        let pushVC = TableViewController()
        let modalVC = TableViewController()
        
        transitionVC.title = "transition"
        pushVC.title = "push"
        modalVC.title = "modal"
        
        let transitionNav = UINavigationController(useDove: true, rootViewController: transitionVC)
        transitionNav.tabBarTransitionAnimation = DVTransitionAnimation.flipOver(duration: 0.25,
                                                                                 interactiveEnable: true)
        let pushNav = UINavigationController(useDove: true, rootViewController: pushVC)
        pushNav.tabBarTransitionAnimation = DVTransitionAnimation.translation(duration: 0.25,
                                                                              interactiveEnable: true)
        let modalNav = UINavigationController(useDove: true, rootViewController: modalVC)
        modalNav.tabBarTransitionAnimation = DVTransitionAnimation.crossDissolve(duration: 0.25,
                                                                                 interactiveEnable: true)
        
        tabBarVC.addChild(transitionNav)
        tabBarVC.addChild(pushNav)
        tabBarVC.addChild(modalNav)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
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
