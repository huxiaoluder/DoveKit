//
// ViewController.swift
// DoveKit_Example 
// 
// Created by xiaoming on 2018/10/13.
// Copyright © 2018 CocoaPods. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "bg3").cgImage
        view.backgroundColor = UIColor.gray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
