//
//  FristViewController.swift
//  懒加载
//
//  Created by 王新克 on 2017/6/23.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "消息"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        self.view.backgroundColor = UIColor.white
    }
}
