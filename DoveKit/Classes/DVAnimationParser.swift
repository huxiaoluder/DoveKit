//
// DVAnimationParser.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

internal enum DVViewControllerTransitionType {
    case NavTransition(DVNavigationControllerOperation)
    case TabTransition(DVTabBarControllerOperation)
    case ModalTransiation(DVViewControllerTransitionOperation)
    
    func operation() -> DVTransitionAnimationProtocol {
        switch self {
        case .NavTransition(let op): return op
        case .TabTransition(let op): return op
        case .ModalTransiation(let op): return op
        }
    }
}

internal protocol DVTransitionAnimationProtocol {
    func animation() -> DVTransitionAnimation
}

internal enum DVNavigationControllerOperation: DVTransitionAnimationProtocol {
    case push(DVTransitionAnimation)
    case pop(DVTransitionAnimation)
    
    func animation() -> DVTransitionAnimation {
        switch self {
        case .push(let animation): return animation
        case .pop(let animation): return animation
        }
    }
}

internal enum DVTabBarControllerOperation: DVTransitionAnimationProtocol {
    case left(DVTransitionAnimation)
    case right(DVTransitionAnimation)
    
    func animation() -> DVTransitionAnimation {
        switch self {
        case .left(let animation): return animation
        case .right(let animation): return animation
        }
    }
}

internal enum DVViewControllerTransitionOperation: DVTransitionAnimationProtocol {
    case present(DVTransitionAnimation)
    case dismmis(DVTransitionAnimation)
    
    func animation() -> DVTransitionAnimation {
        switch self {
        case .present(let animation): return animation
        case .dismmis(let animation): return animation
        }
    }
}

/// 转场方向
///
/// - forward:  前进
/// - backward: 回退
public enum HUTransitionOperation {
    case forward
    case backward
}

/// 执行动画的组件
public struct DVTransitionParts {
    public let duration: TimeInterval
    public let fromView: UIView
    public let toView: UIView
    public let containerView: UIView
    public let operation: HUTransitionOperation
    
    /// 动画执行结束后的回调, PS: 必须执行
    /// - reset: 回调参数, 用于转场动画结束必须恢复 fromView 或 toView 状态
    public let completed: (_ reset: (() -> ())?) -> ()
}

internal class DVAnimationParser: NSObject, UIViewControllerAnimatedTransitioning, DVAnimationProvider {
    
    let transitionType: DVViewControllerTransitionType
    
    var tabBarPanGesture: UIPanGestureRecognizer?
    
    var duration: TimeInterval {
        get {
            return transitionType.operation().animation().duration
        }
    }
    
    init(transitionType: DVViewControllerTransitionType) {
        self.transitionType = transitionType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .NavTransition(let operation):
            prepareForTransition(useing: transitionContext, operation: operation)
        case .TabTransition(let operation):
            prepareForTransition(useing: transitionContext, operation: operation)
        case .ModalTransiation(let operation):
            prepareForTransition(useing: transitionContext, operation: operation)
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: DVNavigationControllerOperation) {
        switch operation {
        case .push(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .forward,
                            isDismmis: false)
        case .pop(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .backward,
                            isDismmis: false)
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: DVTabBarControllerOperation) {
        switch operation {
        case .left(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .forward,
                            isDismmis: false)
        case .right(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .backward,
                            isDismmis: false)
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: DVViewControllerTransitionOperation) {
        switch operation {
        case .present(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .forward,
                            isDismmis: false)
        case .dismmis(let animationType):
            beginTransition(useing: animationType,
                            transitionContext: transitionContext,
                            transitionOperation: .backward,
                            isDismmis: true)
        }
    }
    
    private func beginTransition(useing animationType: DVTransitionAnimation, transitionContext: UIViewControllerContextTransitioning, transitionOperation: HUTransitionOperation, isDismmis: Bool) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromView = fromVC.view,
              let toView = toVC.view else { return }
        if !isDismmis {
            addSubView(useing: toView,
                       to: transitionContext.containerView,
                       withTransitionOperation: transitionOperation)
        }
        let transitionParts = DVTransitionParts(duration: duration, fromView: fromView, toView: toView, containerView: transitionContext.containerView, operation: transitionOperation) {
            if let rest = $0 { rest() }
            guard let containerNav = fromVC.navigationController,
                  let containerTab = fromVC.tabBarController else {
                    if let containerNav = toVC.navigationController,
                       let containerTab = toVC.tabBarController {
                        containerTab.tabBarTransitionManager?.interactiveTransitionGesture.isEnabled
                            = containerNav.children.count <= 1 && !transitionContext.transitionWasCancelled
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    return
            }
            containerTab.tabBarTransitionManager?.interactiveTransitionGesture.isEnabled
                = containerNav.children.count <= 1 && !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        matchingAnimation(useing: animationType, transitionParts: transitionParts)
    }
    
    private func addSubView(useing subView: UIView,
                            to superView: UIView,
                            withTransitionOperation operation: HUTransitionOperation) {
        superView.addSubview(subView)
        switch operation {
        case .forward: superView.bringSubviewToFront(subView)
        case .backward: superView.sendSubviewToBack(subView)
        }
    }
    
    private func matchingAnimation(useing animationType: DVTransitionAnimation,
                                   transitionParts: DVTransitionParts) {
        switch animationType {
        case .custom(_, _,let customAnimation): customAnimation(transitionParts)
        case .translation:      transitionByTransilation(using: transitionParts)
        case .defaultPush:      transitionByDefaultPush(using: transitionParts)
        case .presentation:     transitionByPresentation(using: transitionParts)
        case .crossDissolve:    transitionByCrossDissolve(using: transitionParts)
        case .flipOver:         transitionByFlipOver(using: transitionParts)
        case .blindsHorizontal: transitionByBlindsHorizontal(using: transitionParts)
        case .blindsVertical:   transitionByBlindsVertical(using: transitionParts)
        case .brokenScreen:     transitionByBrokenScreen(using: transitionParts)
        }
    }
    
}
