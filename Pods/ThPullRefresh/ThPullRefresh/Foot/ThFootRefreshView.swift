//
//  ThFootRefreshView.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/2.
//  Copyright © 2016年 tanhui. All rights reserved.
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
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum  ThFootRefreshState : Int {
    case none = 0
    case idle = 1
    case refreshing = 2
    case nomore = 3
}

class ThFootRefreshView : ThRefreshBasicView {
    lazy var stateDict : Dictionary<Int,String> = {
        let staDic = Dictionary<Int , String>()
        return staDic
    }()
    lazy var refreshingLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    lazy var noMoreLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    lazy var idleBtn : UIButton = {
       let btn = UIButton()
        self.addSubview(btn)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0), for: UIControlState() )
        btn.addTarget(self, action: #selector(ThFootRefreshView.startRefreshing), for: .touchUpInside)
        return btn
    }()
    lazy var indicateView : UIActivityIndicatorView = {
        let indicateView = UIActivityIndicatorView(activityIndicatorStyle: .white )
        self.refreshingLabel.addSubview(indicateView)
            indicateView.startAnimating()
        return indicateView
    }()
    var state : ThFootRefreshState = .idle {
        didSet{
            self.setStates(state, oldState: oldValue)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleforState(ThFootRefreshTextIdle, state: .idle)
        self.setTitleforState(ThFootRefreshTextRefreshing , state: .refreshing)
        self.setTitleforState(ThFootRefreshTextNomore , state: .nomore )
        self.setStates(state, oldState: .none)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.idleBtn.frame = self.bounds
        self.refreshingLabel.frame = self.bounds
        self.noMoreLabel.frame = self.bounds
        self.indicateView.center = CGPoint(x: self.center.x-100,y: self.center.y)
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil{
            newSuperview!.addObserver(self, forKeyPath: ThRefreshPanKey, options: .new , context: nil)
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            self.height = ThFootRefreshHeight
            self.scrollView?.th_insetB += self.height
            self.adjustFrameOfContentSize()
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.state == .idle{
            if keyPath == ThRefreshPanKey{
                //不超过一个屏幕
                if ((self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetT)! <= self.scrollView?.height){
                    if(self.scrollView?.th_offsetY > 0-(self.scrollView?.th_insetT)!){
                        self.startRefreshing()
                    }
                }else if((self.scrollView?.contentOffset.y)!+(self.scrollView?.height)!>(self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetB)!){
                    //超过一个屏幕
                    self.startRefreshing()
                }
                
            }else if keyPath == ThHeadRefreshContentOffset{
                self.adjustStateWithContentOffset()
            }
        }
        self.adjustFrameOfContentSize()
    }
    
    
    func setTitleforState(_ title :String, state : ThFootRefreshState){
        if title.isEmpty{
            return
        }
        switch (title){
            case ThFootRefreshTextIdle :
                self.idleBtn .setTitle(title, for: UIControlState())
                break
            case ThFootRefreshTextRefreshing :
                self.refreshingLabel.text = title
                break
            case ThFootRefreshTextNomore :
                self.noMoreLabel.text = title
                break
            default :
                break
        }
    }
    fileprivate func adjustFrameOfContentSize(){
        self.y = (self.scrollView?.contentSize.height)!
    }
    fileprivate func adjustStateWithContentOffset(){
        if self.height<=0{
            return
        }
        if (self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetT)! > self.scrollView?.height{
            //超过一个屏幕
            if((self.scrollView?.contentOffset.y)!+(self.scrollView?.height)!>(self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetB)!){
                self.startRefreshing()
            }

        }
    }
    fileprivate func setStates (_ newState:ThFootRefreshState , oldState:ThFootRefreshState){
        if newState==oldState{
            return
        }
        switch newState {
        case .idle :
            self.noMoreLabel.isHidden = true
            self.refreshingLabel.isHidden = true
            self.idleBtn.isHidden = true
            UIView.animate(withDuration: ThRefreshShortDuration, animations: { () -> Void in
                self.idleBtn.isHidden = false
            })
            break
        case .nomore :
            self.noMoreLabel.isHidden = true
            self.refreshingLabel.isHidden = true
            self.idleBtn.isHidden = true
            UIView.animate(withDuration: ThRefreshShortDuration, animations: { () -> Void in
                self.noMoreLabel.isHidden = false
            })
            break
        case .refreshing :
            self.noMoreLabel.isHidden = true
            self.refreshingLabel.isHidden = true
            self.idleBtn.isHidden = true
            if oldState == .idle{
                UIView.animate(withDuration: ThRefreshShortDuration, animations: { () -> Void in
                    self.refreshingLabel.isHidden = false
                })
                if self.refreshClosure != nil{
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
    func startRefreshing(){
        self.state = .refreshing
    }
    func footEndRefreshing(){
        self.state = .idle
    }
    deinit{
        self.superview?.removeObserver(self, forKeyPath: "contentOffset" ,context: nil)
        self.superview?.removeObserver(self, forKeyPath: ThRefreshPanKey ,context: nil)
    }
}
