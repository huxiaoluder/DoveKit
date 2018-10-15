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

private let defaultAnimation = DVTransitionAnimation.defaultPush(duration: 0.3, interactiveEnable: true)

public class NavigationControllerTransitionManager: NSObject, UINavigationControllerDelegate {
    
    private var allowPopInteractive = false
    
    private weak var targetViewController: UINavigationController?
    
    internal let interactivePopGesture = UIScreenEdgePanGestureRecognizer()
    
    private let interactiveDriven = UIPercentDrivenInteractiveTransition()
    
    init(targetViewController: UINavigationController) {
        targetViewController.view.addGestureRecognizer(interactivePopGesture)
        self.targetViewController = targetViewController
        interactivePopGesture.edges = .left
        super.init()
        targetViewController.delegate = self
        interactivePopGesture.addTarget(self, action: #selector(popByGesture(gesture:)))
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowPopInteractive ? interactiveDriven : nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return  DVAnimationParser(transitionType:
                .NavTransition(operation == .push ?
                .push(fromVC.navigationTransitionAnimation ?? defaultAnimation) :
                .pop(toVC.navigationTransitionAnimation ?? defaultAnimation)))
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let targetIndex = navigationController.children.count - 2
        interactivePopGesture.isEnabled = targetIndex < 0 ? false : navigationController.children[targetIndex].navigationTransitionAnimation?.interactiveEnable ?? defaultAnimation.interactiveEnable
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
