//
// Dove.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

private let presentTransitionManagerKey = UnsafeRawPointer("presentTransitionManager")

private let tabBarTransitionAnimationKey = UnsafeRawPointer("tabBarTransitionAnimation")

private let presentTransitionAnimationKey = UnsafeRawPointer("presentTransitionAnimation")

private let navigationTransitionAnimationKey = UnsafeRawPointer("navigationTransitionAnimation")

extension UIViewController {
    
    internal var presentTransitionManager : ViewControllerTransitioningManager? {
        set {
            objc_setAssociatedObject(self,
                                     presentTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            presentTransitionManagerKey) as? ViewControllerTransitioningManager
        }
    }
    
    public var presentTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     presentTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            presentTransitionAnimationKey) as? DVTransitionAnimation
        }
    }
    
    public var navigationTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     navigationTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            navigationTransitionAnimationKey) as? DVTransitionAnimation
        }
    }
    
    public var tabBarTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     tabBarTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            tabBarTransitionAnimationKey) as? DVTransitionAnimation
        }
    }

    
    @objc convenience public init(useDove: Bool) {
        self.init()
        if useDove {
            presentTransitionManager = ViewControllerTransitioningManager(targetViewController: self)
        }
    }
}

private let navgationTransitionManagerKey = UnsafeRawPointer("navgationTransitionManager")

extension UINavigationController {
    
    internal var navgationTransitionManager: NavigationControllerTransitionManager? {
        set {
            objc_setAssociatedObject(self,
                                     navgationTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            navgationTransitionManagerKey) as? NavigationControllerTransitionManager
        }
    }
    
    convenience public init(useDove: Bool) {
        self.init()
        if useDove {
            navgationTransitionManager = NavigationControllerTransitionManager(targetViewController: self)
        }
    }
    
    convenience public init(useDove: Bool, rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
        if useDove {
            navgationTransitionManager = NavigationControllerTransitionManager(targetViewController: self)
        }
    }
}

private let tabBarTransitionManagerKey = UnsafeRawPointer("tabBarTransitionManager")

extension UITabBarController {
    
    public enum DVTransitionPolicy: Int {
        case currentAnimation
        case targetAnimation
    }
    
    public var baseTransitionDirection: DVTransitionPolicy? {
        get {
            return tabBarTransitionManager?.baseTransitionDirection
        }
    }
    
    internal var tabBarTransitionManager: TabBarControllerTransitionManager? {
        set {
            objc_setAssociatedObject(self,
                                     tabBarTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            tabBarTransitionManagerKey) as? TabBarControllerTransitionManager
        }
    }
    
    convenience public init(useDove: Bool) {
        self.init()
        if useDove {
            tabBarTransitionManager = TabBarControllerTransitionManager(targetViewController: self,
                                                                        base: .currentAnimation)
        }
    }
    
    convenience public init(useDove: Bool, base direction: DVTransitionPolicy) {
        self.init()
        if useDove {
            tabBarTransitionManager = TabBarControllerTransitionManager(targetViewController: self,
                                                                        base: direction)
        }
    }
    
}
