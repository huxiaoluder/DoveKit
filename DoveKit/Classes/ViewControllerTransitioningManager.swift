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

private let defaultAnimation = DVTransitionAnimation.presentation(duration: 0.25, interactiveEnable: true)

public class ViewControllerTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private unowned var targetViewController: UIViewController?
    
    internal let interactiveDismmisGesture = UIPanGestureRecognizer()
    
    private let interactiveDriven = UIPercentDrivenInteractiveTransition()
    
    init(targetViewController: UIViewController) {
        super.init()
        interactiveDismmisGesture.addTarget(self, action: #selector(dismmisByGesture(gesture:)))
        interactiveDismmisGesture.isEnabled = false
        targetViewController.transitioningDelegate = self
        targetViewController.modalPresentationStyle = .custom
        targetViewController.view.addGestureRecognizer(interactiveDismmisGesture)
        self.targetViewController = targetViewController
    }
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            let animationType = targetViewController?.presentTransitionAnimation ?? defaultAnimation
            interactiveDismmisGesture.isEnabled = animationType.interactiveEnable
            return DVAnimationParser(transitionType: .ModalTransiation(.present(animationType)))
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationType = targetViewController?.presentTransitionAnimation ?? defaultAnimation
        return DVAnimationParser(transitionType: .ModalTransiation(.dismmis(animationType)))
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveDriven
    }
    
    @objc private func dismmisByGesture(gesture: UIPanGestureRecognizer) {
        guard let targetVC = targetViewController else { return }
        var percent: CGFloat
        switch targetVC.dismissInteractiveDirection {
        case .up:
            percent = -gesture.translation(in: targetVC.view).y/targetVC.view.bounds.height
        case .left:
            percent = -gesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        case .down:
            percent = gesture.translation(in: targetVC.view).y/targetVC.view.bounds.height
        case .right:
            percent = gesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        }
        percent = min(1.0, max(0.0, percent))
        switch gesture.state {
        case .began:
            targetVC.dismiss(animated: true, completion: nil)
        case .changed:
            interactiveDriven.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveDriven.finish()
            } else {
                interactiveDriven.cancel()
            }
        default: break
        }
    }
    
}
