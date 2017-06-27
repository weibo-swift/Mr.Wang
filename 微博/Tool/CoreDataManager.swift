//
//  CoreDataManager.swift
//  微博
//
//  Created by 王新克 on 2017/6/26.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    //1、插入数据的具体操作如下
    /*
     * 通过AppDelegate单利来获取管理的数据上下文对象，操作实际内容
     * 通过NSEntityDescription.insertNewObjectForEntityForName方法创建实体对象
     * 给实体对象赋值
     * 通过saveContext()保存实体对象
      */
    
    class func insertData(title: String,source: String, replyCount:Int, imgsrc: String, ptime:String){
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //创建user对象
        let EntityName = "Home"
        let HomePage = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:context) as! Home
        
        //对象赋值
        HomePage.title = title
        HomePage.source = source
        HomePage.replyCount = Int64(replyCount)
        HomePage.imgsrc = imgsrc
//        HomePage.ptime = ptime
        
        //保存
        app.saveContext()
    }
    
    
    //2、查询数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 使用查询出来的数据
     */
    class func queryData() ->NSArray{
        
        var fetchedObjects = NSArray()
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 20  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Home"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        /*
        //设置查询条件
        let predicate = NSPredicate.init(format: "userID = '2'", "")
        fetchRequest.predicate = predicate
        */
        //查询操作
        do{
            fetchedObjects = try context.fetch(fetchRequest) as! [Home] as NSArray
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
        return fetchedObjects
    }
    //根据title查询数据库中是否存在此条信息，避免重复入库操作
    class func queryDataWithTitle(title:String) ->NSArray{
        
        var fetchedObjects = NSArray()
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 20  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Home"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
       
         //设置查询条件
         let predicate = NSPredicate.init(format: "title = '\(title)'", "")
         fetchRequest.predicate = predicate
 
        //查询操作
        do{
            fetchedObjects = try context.fetch(fetchRequest) as! [Home] as NSArray
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
        return fetchedObjects
    }

    
    //4、删除数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 通过context.delete删除查询出来的某一个对象
     * 通过saveContext()保存修改后的实体对象
     */
    class func deleteData(){
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
//        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Home"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        /*
        //设置查询条件
        let predicate = NSPredicate.init(format: "userID = '2'", "")
        fetchRequest.predicate = predicate
        */
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Home]
            
            //遍历查询的结果
            for info:Home in fetchedObjects{
                //删除对象
                context.delete(info)
                
                //重新保存
                app.saveContext()
            }
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }

    
}
