//
//  ViewController.swift
//  懒加载
//
//  Created by 王新克 on 2017/6/20.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit
import Foundation

import Kingfisher
import ThPullRefresh

let zhangyan = "yanzinanfei"
var resultArray = NSArray()

class HomeViewController: UIViewController {
    
    lazy var tableView : UITableView = {[unowned self] in
       
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        tableView.rowHeight = 90
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        //实现如下
        tableView.addBounceHeadRefresh(self,bgColor:UIColor.green,loadingColor:UIColor.white, action: #selector(loadNewData))
//        tableView.addHeadRefresh(self, action: #selector(loadNewData))
        tableView.addFootRefresh(self, action: #selector(loadMoreData))
  
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultArray = CoreDataManager.queryData()
        
        if !(resultArray.count > 0){
            self.loadNewData()
        }
        self.navigationItem.title = "微博"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_more"), landscapeImagePhone: UIImage(named: "navigationbar_more_highlighted"), style: .plain, target: self, action: #selector(add))

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), landscapeImagePhone: UIImage(named: "navigationbar_pop_highlighted"), style: .plain, target: self, action: #selector(search))
        
        self.view.addSubview(tableView)
    }
}

//代理方法
extension HomeViewController : UITabBarDelegate,UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = HomeTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: zhangyan)

        guard let home : Home = resultArray[indexPath.row] as? Home else    {
            return cell
        }
        cell.titleLabel?.text = home.title
        cell.replyCountLabel?.text = "\(home.replyCount)" + "跟帖"
        cell.sourceLabel?.text = home.source
        
        let url = URL(string: home.imgsrc!)
        cell.subImage?.kf.setImage(with: url, placeholder: UIImage(named: "addbutton-normal"), options: nil, progressBlock: nil, completionHandler: nil)
        
        return  cell
    }
}

//Mark ----- 点击事件
extension HomeViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    @objc fileprivate func add() {
        
        print("add")
    }
    
    @objc fileprivate func search() {
        print("search")
    }

    @objc fileprivate func loadNewData(){
      
        loadData()
        
        //延时1秒执行
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            let subArray = CoreDataManager.queryData()
            resultArray = resultArray.addingObjects(from: subArray as! [Any]) as NSArray
            
            self.tableView.reloadData()
            self.tableView .tableHeadStopRefreshing()
        }
    }
    
    @objc fileprivate func loadMoreData(){
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            
            let subArray = CoreDataManager.queryData()
            resultArray = resultArray.addingObjects(from: subArray as! [Any]) as NSArray
            
            self.tableView.reloadData()
            self.tableView.tableFootStopRefreshing()
        }
    }
    
}
//请求数据
extension HomeViewController{
    
    fileprivate func loadData() {
        SystemUntil.loadingData(urlString : "http://c.m.163.com/nc/article/list/T1348649079062/0-20.html", type : .get, parameters :nil){(_ result : Any) in
        
            guard let resultDict = result as? [String : Any] else{
                return
            }
            
            guard let subArray = resultDict["T1348649079062"] as? [[String : Any]] else{
                return
            }

            for dict in subArray{
                
                let title : String = dict["title"] as! String
                let source : String = dict["source"] as! String
                let replyCount : Int = dict["replyCount"] as! Int
                let imgsrc : String = dict["imgsrc"] as! String
                let dateString : String = dict["ptime"] as! String
                
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let subDate : NSDate = formatter.date(from: dateString)! as NSDate
                
                let array : NSArray = CoreDataManager.queryDataWithTitle(title: title)
                
                if !(array.count > 0){
                   CoreDataManager.insertData(title: title, source: source, replyCount: replyCount, imgsrc: imgsrc, ptime: dateString)
                }
            }
        }
    }
}




