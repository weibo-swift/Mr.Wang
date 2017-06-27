//
//  File.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/27.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit



class ThRefreshBasicView: UIView {
    var refreshTarget : AnyObject?
    var refreshAction : Selector?
    var refreshClosure : (()->())?
    var scrollView : UIScrollView?
    var scrollviewOrignalInsect : UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = .flexibleWidth
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.superview?.removeObserver(self, forKeyPath: ThHeadRefreshContentOffset)
        if (newSuperview != nil){
            newSuperview?.addObserver(self, forKeyPath: ThHeadRefreshContentOffset, options: .new  , context: nil)
            self.x = 0
            self.width = newSuperview!.width
            self.scrollView = newSuperview as? UIScrollView
            self.scrollviewOrignalInsect = (newSuperview as! UIScrollView).contentInset
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
}
