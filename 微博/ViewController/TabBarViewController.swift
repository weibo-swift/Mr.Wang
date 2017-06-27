//
//  TabBarViewController.swift
//  懒加载
//
//  Created by 王新克 on 2017/6/23.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.creatSubViewController()
    }
}

extension TabBarViewController{
    
    func creatSubViewController(){
        
        let view = HomeViewController()
        let nav = UINavigationController(rootViewController: view)
    
        let item1 : UITabBarItem = UITabBarItem(title: "item2", image: UIImage(named: "womail_btn_menu_gt_default"), selectedImage: UIImage(named: "womail_btn_menu_gt_pressed"))
        nav.tabBarItem = item1
        
        let frist = MessageViewController()
        let nav1 = UINavigationController(rootViewController: frist)
        
        let item2 = UITabBarItem(title: "item4", image: UIImage(named: "womail_btn_menu_md_default"), selectedImage: UIImage(named: "womail_btn_menu_md_pressed"))
        nav1.tabBarItem = item2
        
        let sec = FinderViewController()
        let  nav2 = UINavigationController(rootViewController: sec)
        
        let item3 : UITabBarItem = UITabBarItem(title: "item1", image: UIImage(named: "womail_btn_menu_fx_default"), selectedImage:UIImage(named: "womail_btn_menu_fx_pressed"))
        nav2.tabBarItem = item3
        
        let four = PocketViewController()
        let nav3 = UINavigationController(rootViewController: four)
        
        let item4 : UITabBarItem = UITabBarItem(title: "item3", image: UIImage(named: "womail_btn_menu_kd_default"), selectedImage: UIImage(named: "womail_btn_menu_kd_pressed"))
        nav3.tabBarItem = item4
        
        let tabArray = [nav,nav1,nav2,nav3]
        self.viewControllers = tabArray
        
    }
    
}
