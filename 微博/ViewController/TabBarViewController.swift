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
        
        self.addCenterButton(btnimage: UIImage(named: "lxh_haoaio")!, selectedbtnimg: UIImage(named: "lxh_haoaio")!, selector: "addOrderView", view: self.view)
    
    }
}

extension TabBarViewController : UITabBarControllerDelegate{
    
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
        
        let five = UIViewController()
        
        
        let tabArray = [nav,nav1,five,nav2,nav3]
        self.viewControllers = tabArray
        
        self.delegate = self
        
        
    }
    
    //参数说明
    //btnimage 按钮图片
    //selectedbtnimg 点击时图片
    //selector 按钮方法名称
    //view 按钮添加到view  正常是 self.view就可以
    func addCenterButton(btnimage buttonImage:UIImage,selectedbtnimg selectedimg:UIImage,selector:String,view:UIView)
    {
        //创建一个自定义按钮
        let button:UIButton = UIButton(type: UIButtonType.custom)
        //btn.autoresizingMask
        //button大小为适应图片
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
        
        button.setImage(buttonImage, for: UIControlState.normal)
        button.setImage(selectedimg, for: UIControlState.selected)

        //去掉阴影
        button.adjustsImageWhenDisabled = true;
        //按钮的代理方法
        button.addTarget( self, action: Selector(selector), for:UIControlEvents.touchUpInside )
        //高度差
        let heightDifference:CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        if (heightDifference < 0){
//            button.center = self.tabBar.center;
            button.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height + self.view.frame.size.height/2 + 240)
        }
        else
        {
            var center:CGPoint = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        view.addSubview(button);
    }
}
//设置代理，禁止中间controller的点击
extension TabBarViewController{
    
    //MARK: -- UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers![2]  {
           return false
        }
        return true
    }
    
    
    func addOrderView(){
    
        let centerViewControlller = CenterViewController()
        self.present(centerViewControlller, animated: true, completion: nil)
        
    }
}

