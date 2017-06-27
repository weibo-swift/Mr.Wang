//
//  ThHeadRefresh.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/28.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


enum ThHeadRefreshState:Int{
    case none=0
    case idle=1
    case pulling=2
    case refreshing=3
    case willRefresh=4
}

class ThHeadRefreshView: ThRefreshBasicView {
    //public
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func beginRefresh(){
        if(self.window != nil){
            self.state = .refreshing
        }else{
            self.state = .willRefresh
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if(self.state == .willRefresh){
            self.state = .refreshing
        }
    }
    
    
    //private method
    func setStates (_ newState:ThHeadRefreshState , oldState:ThHeadRefreshState){
        if newState==oldState{
            return
        }
        switch(newState){
            
        case .idle:
            if(oldState == .refreshing){
                UIView.animate(withDuration: ThHeadRefreshAnimation, animations: {
                    self.scrollView?.th_insetT -= self.height
                    
                    }, completion: nil)
            }
            break
        case .pulling:
            break
        case .refreshing:
            if(oldState == .pulling || oldState == .willRefresh){
                UIView.animate(withDuration: ThHeadRefreshAnimation, animations: {
                    self.scrollView?.th_insetT=(self.scrollView?.th_insetT)!+self.oringalheight!
                    
                    }, completion: nil)
                if((self.refreshClosure) != nil){
                    self.refreshClosure!()
                }else{
                    self.refreshTarget?.perform(self.refreshAction!)
                }
            }
            break
        default:
            break
        }

    }
    
    func adjustStateWithContentOffset(){
//        print(self.scrollView?.contentOffset.y)

        let offset = self.scrollView?.th_offsetY
        let headExistOffset = 0-(self.scrollView?.contentInset.top)!
        let refreshPoint = headExistOffset - self.height
        if(self.scrollView?.isDragging == true){
            
            if(self.state == .idle && offset<refreshPoint){
                self.state = .pulling
            }else if (self.state == .pulling && offset>=refreshPoint){
                self.state = .idle
            }
        }else if (self.state == .pulling){
            self.state = .refreshing

        }
        
    }
    
    func stopRefreshing(){
            UIView.animate(withDuration: ThHeadRefreshCompleteDuration, animations: { () -> Void in
                self.state = .idle
        }) 
    }
    //override
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath==ThHeadRefreshContentOffset){
            self.adjustStateWithContentOffset()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if(newSuperview != nil){
            self.height = ThHeadRefreshHeight
            self.oringalheight = self.height
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.y = -self.height
        
    }
        
    
    
    var state : ThHeadRefreshState = .idle
        {
        didSet {
            self.setStates(state, oldState: oldValue)
        }
    }
    
    
    var oringalheight : CGFloat?
    var hideTimeLabel : Bool = false
    var hideRefreshTextLabel : Bool = false
}
