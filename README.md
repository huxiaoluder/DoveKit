![DoveKit Logo](./Resource/DoveKit.png)

[![Build Status](https://travis-ci.org/huxiaoluder/DoveKit.svg?branch=1.0.0)](https://travis-ci.org/huxiaoluder/DoveKit)
[![Version](https://img.shields.io/cocoapods/v/DoveKit.svg?style=flat)](https://cocoapods.org/pods/DoveKit)
[![License](https://img.shields.io/cocoapods/l/DoveKit.svg?style=flat)](https://cocoapods.org/pods/DoveKit)
[![Platform](https://img.shields.io/cocoapods/p/DoveKit.svg?style=flat)](https://cocoapods.org/pods/DoveKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![tabbar transiton](./Resource/tabBarTransiton.gif)
![navigation transition](./Resource/navigationTransition.gif)
![presentation transition](./Resource/presentationTransition.gif)

## Requirements

Only support Swift project, because Swift Enumerator is not useful in Objective-C project.

## Usage

* How to use animations

    DoveKit provide some animations for you, and more and more animations will update in the future,
    Enumerator define animation type, you only set the `DVTransitionAnimation.value` to your ViewController,
    If you want animation by yourself, you can use the `DVTransitionAnimation.custom(...)` to define custom animation
        
* TabbarController transition

   ```swift
    // if you want to use TabbarController transition with DoveKit, must call func UITabBarController(useDove:, base:)
    let tabBarVC = UITabBarController(useDove: true, base: .currentAnimation)

    // if you want to use NavigationController transition with DoveKit, must call func UINavigationController(useDove:, rootViewController:)
    let nav1 = UINavigationController(useDove: true, rootViewController: transitionVC)
    transitionNav.tabBarTransitionAnimation = DVTransitionAnimation.?

    let nav2 = UINavigationController(useDove: true, rootViewController: pushVC)
    pushNav.tabBarTransitionAnimation = DVTransitionAnimation.?

    let nav3 = UINavigationController(useDove: true, rootViewController: modalVC)
    modalNav.tabBarTransitionAnimation = DVTransitionAnimation.?
  ```

* NavigationController transition

  ```swift
    // if you want push some viewcontroller with DoveKit, use current viewcontroller.navigationTransitionAnimation.
    // note: nav must be instanced by DoveKit, otherwise it's invalid.
    let vc = UIViewContrller()
    navigationTransitionAnimation = DVTransitionAnimation.?
    navigationController.pushViewController(vc, animated: true)
  ```

* PresentController trasnition

  ```swift
    // if you want present some viewcontroller with DoveKit, instance a viewcontroller by func UIViewController(useDove:) and use viewcontroller.presentTransitionAnimation
    let vc = UIViewController(useDove: true)
    vc.presentTransitionAnimation = DVTransitionAnimation.?
    
    // dismiss gesture direction
    vc.dismissInteractiveDirection = .down
    
    present(vc, animated: true, completion: nil)
  ```

## Installation

DoveKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DoveKit'
```

## Author

xiaoming, huxiaoluder@163.com

## License

DoveKit is available under the MIT license. See the LICENSE file for more info.
