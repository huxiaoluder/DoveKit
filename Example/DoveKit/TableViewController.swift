//
// TableViewController.swift
// DoveKit_Example 
// 
// Created by xiaoming on 2018/10/13.
// Copyright © 2018 CocoaPods. All rights reserved.
//
// Email: huxiaoluder@163.com
//

import UIKit
import DoveKit

private let identifier = "identifier"

class TableViewController: UITableViewController {
    
    let transitionTitles = ["translation","crossDissolve","flipOver","blindsHorizontal","brokenScreen"]
    let pushTitles = ["defaultpush","crossDissolve","flipOver","blindsHorizontal","brokenScreen"]
    let modalTitles = ["presentation","crossDissolve","flipOver","blindsHorizontal","blindsVertical","brokenScreen"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "bg1").cgImage
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "backGround"), for: .default)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.navigationItem.title == "push" {
            return pushTitles.count
        } else if self.navigationItem.title == "transition" {
            return transitionTitles.count
        } else {
            return modalTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        if self.navigationItem.title == "push" {
            cell.textLabel?.text = pushTitles[indexPath.row]
        } else if self.navigationItem.title == "transition" {
            cell.textLabel?.text = transitionTitles[indexPath.row]
        } else {
            cell.textLabel?.text = modalTitles[indexPath.row]
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.navigationItem.title == "push" {
            pushTest(indexPath: indexPath)
        }
        
        if self.navigationItem.title == "transition" {
            tabBarTransitionTest(indexPath: indexPath)
        }
        
        if self.navigationItem.title == "modal" {
            modalTest(indexPath: indexPath)
        }
    }
    
    func pushTest(indexPath: IndexPath) {
        let vc = TableViewController()
        vc.title = "push"
        let nav = navigationController
        if indexPath.row == 0 {
            //            navigationTransitionAnimation = DVTransitionAnimation.defaultPush(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 1 {
            navigationTransitionAnimation = DVTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 2 {
            navigationTransitionAnimation = DVTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true)
        } else if indexPath.row == 3 {
            navigationTransitionAnimation = DVTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 4 {
            navigationTransitionAnimation = DVTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true)
        }
        vc.hidesBottomBarWhenPushed = true
        nav?.pushViewController(vc, animated: true)
    }
    
    func tabBarTransitionTest(indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.tabBarTransitionAnimation = DVTransitionAnimation.translation(duration: 0.3, interactiveEnable: false)
        } else if indexPath.row == 1 {
            navigationController?.tabBarTransitionAnimation = DVTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 2 {
            navigationController?.tabBarTransitionAnimation = DVTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true)
        } else if indexPath.row == 3 {
            navigationController?.tabBarTransitionAnimation = DVTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 4 {
            navigationController?.tabBarTransitionAnimation = DVTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true)
        }
    }
    
    func modalTest(indexPath: IndexPath) {
        let vc = ViewController(useDove: true)
        if indexPath.row == 0 {
            //            vc.presentTransitionAnimation = DVTransitionAnimation.presentation(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 1 {
            vc.presentTransitionAnimation = DVTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 2 {
            vc.presentTransitionAnimation = DVTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true)
        } else if indexPath.row == 3 {
            vc.presentTransitionAnimation = DVTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 4 {
            vc.presentTransitionAnimation = DVTransitionAnimation.blindsVertical(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 5 {
            vc.presentTransitionAnimation = DVTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
}
