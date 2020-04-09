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

private var presentTransitionManagerKey = "presentTransitionManager"

private var navgationTransitionManagerKey = "navgationTransitionManager"

private var tabBarTransitionManagerKey = "tabBarTransitionManager"

private var dismissInteractiveDrectionKey = "dismissInteractiveDrection"

private var tabBarTransitionAnimationKey = "tabBarTransitionAnimation"

private var presentTransitionAnimationKey = "presentTransitionAnimation"

private var navigationTransitionAnimationKey = "navigationTransitionAnimation"

extension UIViewController {
    
    public enum DVDirection {
        case up,left,down,right
    }
    
    internal var presentTransitionManager : ViewControllerTransitioningManager? {
        set {
            objc_setAssociatedObject(self,
                                     &presentTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &presentTransitionManagerKey) as? ViewControllerTransitioningManager
        }
    }
    
    /**
     Note:  Dismiss gesture direction is affected by presentationView.layer.transform,
            if layer.transform changed by animation, you need to correct the direction of the gesture,
            because layer.transform was changed when animation begining, not animation ended.
            default value is .down
     */
    public var dismissInteractiveDirection : DVDirection {
        set {
            objc_setAssociatedObject(self,
                                     &dismissInteractiveDrectionKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &dismissInteractiveDrectionKey) as? DVDirection ?? .down
        }
    }
    
    /// If nil, default value is .presentation in DoveKit
    public var presentTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     &presentTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &presentTransitionAnimationKey) as? DVTransitionAnimation
        }
    }
    
    
    /// If nil,default value is .defaultPush in DoveKit
    public var navigationTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     &navigationTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &navigationTransitionAnimationKey) as? DVTransitionAnimation
        }
    }
    
    /// If nil,default value is .translation in DoveKit
    public var tabBarTransitionAnimation: DVTransitionAnimation? {
        set {
            objc_setAssociatedObject(self,
                                     &tabBarTransitionAnimationKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &tabBarTransitionAnimationKey) as? DVTransitionAnimation
        }
    }
    
    @objc convenience public init(useDove: Bool) {
        self.init()
        if useDove {
            presentTransitionManager = .init(targetViewController: self)
        }
    }
}

extension UINavigationController {
    
    public var navgationTransitionManager: NavigationControllerTransitionManager? {
        set {
            objc_setAssociatedObject(self,
                                     &navgationTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let value = objc_getAssociatedObject(self,
                                                 &navgationTransitionManagerKey) as? NavigationControllerTransitionManager
            return value
        }
    }
    
    convenience public init(useDove: Bool) {
        self.init(useDove: useDove)
        if useDove {
            navgationTransitionManager = .init(targetViewController: self)
        }
    }
    
    convenience public init(useDove: Bool, rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
        if useDove {
            presentTransitionManager = .init(targetViewController: self)
            navgationTransitionManager = .init(targetViewController: self)
        }
    }
}

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
                                     &tabBarTransitionManagerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self,
                                            &tabBarTransitionManagerKey) as? TabBarControllerTransitionManager
        }
    }
    
    convenience public init(useDove: Bool, base direction: DVTransitionPolicy = .currentAnimation) {
        self.init(useDove: useDove)
        if useDove {
            tabBarTransitionManager = .init(targetViewController: self, base: direction)
        }
    }
    
}
