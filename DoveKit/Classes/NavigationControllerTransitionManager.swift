//
// NavigationControllerTransitionManager.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

private let defaultAnimation = DVTransitionAnimation.defaultPush(duration: 0.25, interactiveEnable: true)

public class NavigationControllerTransitionManager: NSObject, UINavigationControllerDelegate {
    
    private var allowPopInteractive = false
    
    private unowned var targetViewController: UINavigationController?
    
    internal let interactivePopGesture = UIScreenEdgePanGestureRecognizer()
    
    private let interactiveDriven = UIPercentDrivenInteractiveTransition()
    
    init(targetViewController: UINavigationController) {
        super.init()
        interactivePopGesture.edges = .left
        interactivePopGesture.addTarget(self, action: #selector(popByGesture(gesture:)))
        targetViewController.delegate = self
        targetViewController.view.addGestureRecognizer(interactivePopGesture)
        self.targetViewController = targetViewController
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return allowPopInteractive ? interactiveDriven : nil
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return DVAnimationParser(transitionType:
                .NavTransition(operation == .push ?
                    .push(fromVC.navigationTransitionAnimation ?? defaultAnimation) :
                    .pop(toVC.navigationTransitionAnimation ?? defaultAnimation)))
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        if navigationController.viewControllers.count > 1 {
           interactivePopGesture.isEnabled = viewController.navigationTransitionAnimation?.interactiveEnable ?? defaultAnimation.interactiveEnable
        } else {
            interactivePopGesture.isEnabled = false
        }
    }
    
    @objc private func popByGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let targetVC = targetViewController else { return }
        var percent = gesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        percent = min(1.0, max(0.0, percent))
        switch gesture.state {
        case .began:
            allowPopInteractive = true
            targetVC.popViewController(animated: true)
        case .changed:
            interactiveDriven.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveDriven.finish()
            } else {
                interactiveDriven.cancel()
            }
            allowPopInteractive = false
        default: break
        }
    }
    
}
