//
//  systemUntil.swift
//  懒加载
//
//  Created by 王新克 on 2017/6/22.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}


class SystemUntil: NSObject {

    class func loadingData(urlString : String, type : MethodType, parameters : [String : Any]? = nil, finishedCallBack : @escaping(_ result : Any) -> ()) {
        
        let method = type == MethodType.get ? HTTPMethod.get : HTTPMethod.post
        
        DispatchQueue.global().async {
            
            Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
                guard let result = response.result.value else{ return }
                
                print("\(result)")
          
                finishedCallBack(result)
            }
        }
    }
    
    
    
    enum Validate {
        case email(_: String)
        case phoneNum(_: String)
        case carNum(_: String)
        case username(_: String)
        case password(_: String)
        case nickname(_: String)
        
        case URL(_: String)
        case IP(_: String)
        
        
        var isRight: Bool {
            var predicateStr:String!
            var currObject:String!
            switch self {
            case let .email(str):
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                currObject = str
            case let .phoneNum(str):
                predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
                currObject = str
            case let .carNum(str):
                predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
                currObject = str
            case let .username(str):
                predicateStr = "^[A-Za-z0-9]{6,20}+$"
                currObject = str
            case let .password(str):
                predicateStr = "^[a-zA-Z0-9]{6,20}+$"
                currObject = str
            case let .nickname(str):
                predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
                currObject = str
            case let .URL(str):
                predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
                currObject = str
            case let .IP(str):
                predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
                currObject = str
            }
            
            let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
            return predicate.evaluate(with: currObject)
        }
    }
    
}
