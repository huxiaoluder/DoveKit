//
// DVAnimationProvider.swift
// DoveKit
// 
// Created by xiaoming on 2018/10/11.
// Copyright © 2018 freecoder. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

/// 框架自带动画类型
///
/// - custom->: 自定义转场方式, 自己发挥, PS: 当你在custom中, 使用系统提供的转场动画时,必须关闭手势响应(原因: 系统转场不管成功失败默认移除 fromView, 如果手势控制转场失败 toView 也会被移除, containerView上的 view 将被清空, 无法继续执行转场)
/// - translation:      平移动画, tabBarController 默认动画, PS: 建议只用于tabBarController转场
/// - defaultPush:      平移动画, navigationController 默认动画, PS: 建议只用于navigationController转场
/// - presentation:     底部推出, presentController 默认动画, PS: 建议只用于Modal转场
/// - crossDissolve:    逐渐消融
/// - flipOver:         页面翻转
/// - blindsHorizontal: 水平百叶窗
/// - blindsVertical:   垂直百叶窗
/// - brokenScreen:     碎屏动画
public enum DVTransitionAnimation {
    case custom(duration: TimeInterval, interactiveEnable: Bool, animation: (DVTransitionParts) -> ())
    
    case translation(duration: TimeInterval, interactiveEnable: Bool)
    case defaultPush(duration: TimeInterval, interactiveEnable: Bool)
    case presentation(duration: TimeInterval, interactiveEnable: Bool)
    
    case crossDissolve(duration: TimeInterval, interactiveEnable: Bool)
    case flipOver(duration: TimeInterval, interactiveEnable: Bool)
    case blindsHorizontal(duration: TimeInterval, interactiveEnable: Bool)
    case blindsVertical(duration: TimeInterval, interactiveEnable: Bool)
    case brokenScreen(duration: TimeInterval, interactiveEnable: Bool)
    
    var duration: TimeInterval {
        switch self {
        case .custom(let duration, _, _):           return duration
        case .translation(let duration, _):         return duration
        case .defaultPush(let duration, _):         return duration
        case .presentation(let duration, _):        return duration
        case .crossDissolve(let duration, _):       return duration
        case .flipOver(let duration, _):            return duration
        case .blindsHorizontal(let duration, _):    return duration
        case .blindsVertical(let duration, _):      return duration
        case .brokenScreen(let duration, _):        return duration
        }
    }
    
    var interactiveEnable: Bool {
        switch self {
        case .custom(_, let interactiveEnable, _):          return interactiveEnable
        case .translation(_, let interactiveEnable):        return interactiveEnable
        case .defaultPush(_, let interactiveEnable):        return interactiveEnable
        case .presentation(_, let interactiveEnable):       return interactiveEnable
        case .crossDissolve(_, let interactiveEnable):      return interactiveEnable
        case .flipOver(_, let interactiveEnable):           return interactiveEnable
        case .blindsHorizontal(_, let interactiveEnable):   return interactiveEnable
        case .blindsVertical(_, let interactiveEnable):     return interactiveEnable
        case .brokenScreen(_, let interactiveEnable):       return interactiveEnable
        }
    }
    
}

internal protocol DVAnimationProvider {
    
    // 三种方式的默认动画类型
    func transitionByTransilation(using transitionParts: DVTransitionParts)
    func transitionByDefaultPush(using transitionParts: DVTransitionParts)
    func transitionByPresentation(using transitionParts: DVTransitionParts)
    
    // 其他动画类型
    func transitionByCrossDissolve(using transitionParts: DVTransitionParts)
    func transitionByFlipOver(using transitionParts: DVTransitionParts)
    func transitionByBlindsHorizontal(using transitionParts: DVTransitionParts)
    func transitionByBlindsVertical(using transitionParts: DVTransitionParts)
    func transitionByBrokenScreen(using transitionParts: DVTransitionParts)
}

extension DVAnimationProvider {
    
    func transitionByTransilation(using transitionParts: DVTransitionParts) {
        let width = transitionParts.containerView.bounds.width
        var fromViewTransform = CGAffineTransform.identity
        if transitionParts.operation == .forward {
            transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: -width, y: 0)
        } else {
            transitionParts.toView.transform = CGAffineTransform(translationX: -width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: width, y: 0)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = CGAffineTransform.identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed({
                transitionParts.fromView.transform = .identity
                transitionParts.toView.transform = .identity
            })
        }
    }
    
    func transitionByDefaultPush(using transitionParts: DVTransitionParts) {
        let width = transitionParts.containerView.bounds.width
        var fromViewTransform = CGAffineTransform.identity
        if transitionParts.operation == .forward {
            transitionParts.toView.layer.shadowColor = UIColor.black.cgColor
            transitionParts.toView.layer.shadowOpacity = 0.6
            transitionParts.toView.layer.shadowRadius = 5;
            transitionParts.toView.layer.shadowOffset = CGSize(width: -5, height: 0)
            transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: -width/2, y: 0)
        } else {
            transitionParts.fromView.layer.shadowColor = UIColor.black.cgColor
            transitionParts.fromView.layer.shadowOpacity = 0.6
            transitionParts.fromView.layer.shadowRadius = 5;
            transitionParts.fromView.layer.shadowOffset = CGSize(width: -5, height: 0)
            transitionParts.toView.transform = CGAffineTransform(translationX: -width/2, y: 0)
            fromViewTransform = CGAffineTransform(translationX: width, y: 0)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = CGAffineTransform.identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed {
                transitionParts.toView.transform = .identity
                transitionParts.fromView.transform = .identity
            }
        }
    }
    
    func transitionByPresentation(using transitionParts: DVTransitionParts) {
        let height = transitionParts.containerView.bounds.height
        var fromViewTransform : CGAffineTransform = .identity
        if transitionParts.operation == .forward {
            transitionParts.toView.transform = CGAffineTransform(translationX: 0, y: height)
        } else {
            fromViewTransform = CGAffineTransform(translationX: 0, y: height)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = .identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed(nil)
        }
    }
    
    func transitionByCrossDissolve(using transitionParts: DVTransitionParts) {
        transitionParts.toView.alpha = 0
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.alpha = 1
                        transitionParts.fromView.alpha = 0
        }) { (_) in
            transitionParts.completed({
                transitionParts.fromView.alpha = 1
                transitionParts.toView.alpha = 1
            })
        }
    }
    
    func transitionByFlipOver(using transitionParts: DVTransitionParts) {
        transitionParts.fromView.layer.isDoubleSided = false
        transitionParts.toView.layer.isDoubleSided = false
        var fromViewTransform: CATransform3D
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            fromViewTransform.m34 = -1.0/500.0
            transitionParts.toView.layer.transform = CATransform3DMakeRotation(-.pi, 0, 1, 0)
            transitionParts.toView.layer.transform.m34 = -1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(-.pi, 0, 1, 0)
            fromViewTransform.m34 = 1.0/500.0
            transitionParts.toView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            transitionParts.toView.layer.transform.m34 = 1.0/500.0
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.fromView.layer.transform = fromViewTransform
                        transitionParts.toView.layer.transform = CATransform3DIdentity
        }) { (_) in
            transitionParts.completed {
                transitionParts.fromView.layer.isDoubleSided = true
                transitionParts.toView.layer.isDoubleSided = true
                transitionParts.fromView.layer.transform = CATransform3DIdentity
                transitionParts.toView.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    func transitionByBlindsHorizontal(using transitionParts: DVTransitionParts) {
        let rectCount = DVRectCount(line: 1, culom: UInt(UIScreen.main.bounds.width/25))
        let fromViewContentInset = UIEdgeInsets(top: transitionParts.fromView.frame.minY,
                                                left: 0, bottom: 0, right: 0)
        let toViewContentInset = UIEdgeInsets(top: transitionParts.toView.frame.minY,
                                              left: 0, bottom: 0, right: 0)
        let toViews = transitionParts.toView.shearThrough(based: rectCount,
                                                          afterScreenUpdates: true,
                                                          withCapInsets: toViewContentInset) {
                                                            $0.layer.isDoubleSided = false
                                                            transitionParts.containerView.addSubview($0)
                                                            if transitionParts.operation == .forward {
                                                                $0.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
                                                                $0.layer.transform.m34 = -1.0/500.0
                                                            } else {
                                                                $0.layer.transform = CATransform3DMakeRotation(-.pi, 0, 1, 0)
                                                                $0.layer.transform.m34 = 1.0/500.0
                                                            }
        }
        let fromViews = transitionParts.fromView.shearThrough(based: rectCount,
                                                              afterScreenUpdates: false,
                                                              withCapInsets: fromViewContentInset) {
                                                                $0.layer.isDoubleSided = false
                                                                transitionParts.containerView.addSubview($0)
        }
        var fromViewTransform = CATransform3DIdentity
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            fromViewTransform.m34 = -1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(-.pi, 0, 1, 0)
            fromViewTransform.m34 = 1.0/500.0
        }
        let width = transitionParts.containerView.bounds.width
        transitionParts.fromView.transform = CGAffineTransform(translationX: width, y: 0)
        transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for toView in toViews {
                            toView.layer.transform = CATransform3DIdentity
                        }
                        for fromView in fromViews {
                            fromView.layer.transform = fromViewTransform
                        }
        }) { (_) in
            transitionParts.fromView.transform = .identity
            transitionParts.toView.transform = .identity
            for view in fromViews+toViews {
                view.removeFromSuperview()
            }
            transitionParts.completed(nil)
        }
    }
    
    func transitionByBlindsVertical(using transitionParts: DVTransitionParts) {
        let rectCount = DVRectCount(line: UInt(UIScreen.main.bounds.height/25), culom: 1)
        let fromViewContentInset = UIEdgeInsets(top: transitionParts.fromView.frame.minY,
                                                left: 0, bottom: 0, right: 0)
        let toViewContentInset = UIEdgeInsets(top: transitionParts.toView.frame.minY,
                                              left: 0, bottom: 0, right: 0)
        let toViews = transitionParts.toView.shearThrough(based: rectCount,
                                                          afterScreenUpdates: true,
                                                          withCapInsets: toViewContentInset) {
                                                            $0.layer.isDoubleSided = false
                                                            transitionParts.containerView.addSubview($0)
                                                            if transitionParts.operation == .forward {
                                                                $0.layer.transform = CATransform3DMakeRotation(-.pi, 1, 0, 0)
                                                                $0.layer.transform.m34 = 1.0/500.0
                                                            } else {
                                                                $0.layer.transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
                                                                $0.layer.transform.m34 = -1.0/500.0
                                                            }
        }
        let fromViews = transitionParts.fromView.shearThrough(based: rectCount,
                                                              afterScreenUpdates: false,
                                                              withCapInsets: fromViewContentInset) {
                                                                $0.layer.isDoubleSided = false
                                                                transitionParts.containerView.addSubview($0)
        }
        var fromViewTransform = CATransform3DIdentity
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(-.pi, 1, 0, 0)
            fromViewTransform.m34 = 1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(.pi, 1, 0, 0)
            fromViewTransform.m34 = -1.0/500.0
        }
        let width = transitionParts.containerView.bounds.width
        transitionParts.fromView.transform = CGAffineTransform(translationX: width, y: 0)
        transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for toView in toViews {
                            toView.layer.transform = CATransform3DIdentity
                        }
                        for fromView in fromViews {
                            fromView.layer.transform = fromViewTransform
                        }
        }) { (_) in
            transitionParts.fromView.transform = .identity
            transitionParts.toView.transform = .identity
            for view in fromViews+toViews {
                view.removeFromSuperview()
            }
            transitionParts.completed(nil)
        }
    }
    
    func transitionByBrokenScreen(using transitionParts: DVTransitionParts) {
        let proportion = transitionParts.containerView.bounds.width / transitionParts.containerView.bounds.height
        let rectCount = DVRectCount(line: UInt(UIScreen.main.bounds.height/20*proportion),
                                    culom: UInt(UIScreen.main.bounds.width/20))
        let fromViewContentInset = UIEdgeInsets(top: transitionParts.fromView.frame.minY,
                                                left: 0, bottom: 0, right: 0)
        let fromViews = transitionParts.fromView.shearThrough(based: rectCount, afterScreenUpdates: false, withCapInsets: fromViewContentInset) {
            transitionParts.containerView.addSubview($0)
        }
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random())/100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        transitionParts.fromView.transform = CGAffineTransform(translationX: transitionParts.containerView.bounds.width, y: 0)
        let height = transitionParts.containerView.bounds.height
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for fromView in fromViews {
                            let xOffset = randomFloatBetween(-200 , and: 200)
                            let yOffset = randomFloatBetween(height, and: height * 1.3)
                            fromView.layer.transform = CATransform3DMakeTranslation(xOffset, yOffset, 0)
                            fromView.alpha = 0;
                        }
        }) { (_) in
            for view in fromViews {
                view.removeFromSuperview()
            }
            transitionParts.completed({
                transitionParts.fromView.transform = .identity
            })
        }
    }
    
}


struct DVRectCount {
    let line: UInt
    let culom: UInt
}

extension UIView {
    
    /// 基于矩阵类型切割视图
    ///
    /// - Parameters:
    ///   - rectCount:  基于切🈹的矩阵类型
    ///   - isUpdate:   是否强制视图渲染完毕后才切割
    ///   - inset:      基于切🈹的内边距
    ///   - expression: 对切🈹好的 view 进行相应的处理
    /// - Returns:      切🈹好的 views
    func shearThrough(based rectCount: DVRectCount,
                      afterScreenUpdates isUpdate: Bool,
                      withCapInsets inset: UIEdgeInsets,
                      dealWith expression: (UIView) -> ()) -> [UIView] {
        var views = [UIView]()
        guard rectCount.line != 0 && rectCount.culom != 0 else { return views }
        let width = frame.width/CGFloat(rectCount.culom)
        let height = frame.height/CGFloat(rectCount.line)
        for i in 0..<rectCount.line {
            let y = CGFloat(i)*height
            for j in 0..<rectCount.culom {
                let x = CGFloat(j)*width
                var frame = CGRect(x: x, y: y, width: width, height: height)
                guard let view = resizableSnapshotView(from: frame, afterScreenUpdates: isUpdate, withCapInsets: .zero) else { return views }
                frame.origin.y += inset.top
                view.frame = frame
                expression(view)
                views.append(view)
            }
        }
        return views
    }
    
}
