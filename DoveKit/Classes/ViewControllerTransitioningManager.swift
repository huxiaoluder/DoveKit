//
// ViewControllerTransitioningManager.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

private let defaultAnimation = DVTransitionAnimation.presentation(duration: 0.3, interactiveEnable: true)

public class ViewControllerTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private var allowDismmisInteractive = false
    
    private weak var targetViewController: UIViewController?
    
    internal let interactiveDismmisGesture = UIPanGestureRecognizer()
    
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    init(targetViewController: UIViewController) {
        targetViewController.modalPresentationStyle = .custom
        targetViewController.view.addGestureRecognizer(interactiveDismmisGesture)
        self.targetViewController = targetViewController
        super.init()
        targetViewController.transitioningDelegate = self
        interactiveDismmisGesture.addTarget(self, action: #selector(dismmisByGesture(gesture:)))
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationType = targetViewController?.presentTransitionAnimation ?? defaultAnimation
        interactiveDismmisGesture.isEnabled = animationType.interactiveEnable
        return DVAnimationParser(transitionType: .ModalTransiation(.present(animationType)))
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationType = targetViewController?.presentTransitionAnimation ?? defaultAnimation
        return DVAnimationParser(transitionType: .ModalTransiation(.dismmis(animationType)))
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowDismmisInteractive ? interactiveTransition : nil
    }
    
    @objc private func dismmisByGesture(gesture: UIPanGestureRecognizer) {
        guard let targetVC = targetViewController else { return }
        var percent = gesture.translation(in: targetVC.view).y/targetVC.view.bounds.height
        percent = min(percent, 1.0)
        switch gesture.state {
        case .began:
            allowDismmisInteractive = true
            targetVC.dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransition.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            interactiveTransition.completionSpeed = 1
            allowDismmisInteractive = false
        default: break
        }
    }
    
}
