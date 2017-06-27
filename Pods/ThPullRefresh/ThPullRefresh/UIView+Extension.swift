//
//  UIView+Extension.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/27.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    var centerY : CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    var centerX : CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    var bottom : CGFloat {
        get {
            return self.y+self.height
        }
    }
    var right : CGFloat{
        get {
            return self.x+self.width
        }
    }
    var x : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var y : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var width : CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x,
                y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    var height : CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x,
                y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    var size : CGSize {
        get {
            return self.frame.size
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x,
                y: self.frame.origin.y, width: newValue.width, height: newValue.height)
        }
    }
}
