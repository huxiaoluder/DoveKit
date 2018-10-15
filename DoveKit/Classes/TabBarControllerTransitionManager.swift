//
// TabBarControllerTransitionManager.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

internal enum DVDirection: CGFloat {
    case left = -1
    case none = 0
    case right = 1
}

private let defaultAnimation = DVTransitionAnimation.translation(duration: 0.3, interactiveEnable: true)

public class TabBarControllerTransitionManager: NSObject, UITabBarControllerDelegate {
    
    private var slidingDirection: DVDirection = .none
    
    private var allowTransitonInteractive = false
    
    private weak var targetViewController: UITabBarController?
    
    internal let interactiveTransitionGesture = UIPanGestureRecognizer()
    
    private let interactiveDriven = UIPercentDrivenInteractiveTransition()
    
    internal var baseTransitionDirection: UITabBarController.DVTransitionPolicy
    
    init(targetViewController: UITabBarController,
                base direction: UITabBarController.DVTransitionPolicy) {
        baseTransitionDirection = direction
        self.targetViewController = targetViewController
        self.targetViewController?.view.addGestureRecognizer(interactiveTransitionGesture)
        super.init()
        interactiveTransitionGesture.addTarget(self, action: #selector(transitionByGesture(gesture:)))
        targetViewController.delegate = self
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowTransitonInteractive ? interactiveDriven : nil
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = tabBarController.children.index(of: fromVC)!
        let toIndex = tabBarController.children.index(of: toVC)!
        let baseAnimationVC = baseTransitionDirection == .currentAnimation ? fromVC : toVC
        let animationType = baseAnimationVC.tabBarTransitionAnimation ?? defaultAnimation
        let operation = fromIndex < toIndex ?
            DVTabBarControllerOperation.left(animationType) :
            DVTabBarControllerOperation.right(animationType)
        return DVAnimationParser(transitionType: .TabTransition(operation))
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        interactiveTransitionGesture.isEnabled = viewController.tabBarTransitionAnimation?.interactiveEnable ??
            defaultAnimation.interactiveEnable
    }
    
    @objc private func transitionByGesture(gesture: UIPanGestureRecognizer) {
        guard let targetVC = targetViewController else { return }
        var percent = slidingDirection.rawValue*gesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        percent = min(1.0, max(0.0, percent))
        switch gesture.state {
        case .began:
            allowTransitonInteractive = true
            if gesture.velocity(in: targetVC.view).x > 0 {
                if targetVC.selectedIndex > 0 {
                    targetVC.selectedIndex -= 1
                    slidingDirection = .right
                }
            } else {
                if targetVC.selectedIndex < targetVC.children.count - 1 {
                    targetVC.selectedIndex += 1
                    slidingDirection = .left
                }
            }
        case .changed:
            interactiveDriven.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveDriven.finish()
            } else {
                interactiveDriven.cancel()
            }
            interactiveDriven.completionSpeed = 1
            allowTransitonInteractive = false
            slidingDirection = .none
        default: break
        }
    }
    
}
