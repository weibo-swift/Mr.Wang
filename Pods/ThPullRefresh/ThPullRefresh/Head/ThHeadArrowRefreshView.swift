//
//  ThHeadArrowRefresh.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/1.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import Foundation
import UIKit

class ThHeadArrowRefreshView : ThHeadRefreshView {
    
    lazy var arrow : UIImageView = {
        let path = "ThRefresh.bundle" as NSString
        let whole = path.appendingPathComponent("arrow.png")
        let arrow = UIImageView(image: UIImage(named: whole))
        arrow.contentMode = .scaleAspectFit
        self.addSubview(arrow)
        return arrow
    }()
    lazy var indicateView : UIActivityIndicatorView = {
        let indicateView = UIActivityIndicatorView(activityIndicatorStyle: .white )
        self.addSubview(indicateView)
        return indicateView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleforState(ThHeadRefreshTextRefreshing, state: .refreshing )
        self.setTitleforState(ThHeadRefreshTextIdle, state: .idle)
        self.setTitleforState(ThHeadRefreshTextPulling, state: .pulling)
        self.setValue(ThHeadRefreshTimeKey, forKey: "dataKey")
        self.setStates(.idle, oldState: .none)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.arrow.center = CGPoint(x: self.width*0.5-100, y: self.height*0.5)
        self.indicateView.center = self.arrow.center
        
        if(self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.DataLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && self.hideTimeLabel){
            self.stateLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.stateLabel.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height*0.55)
            self.DataLabel.frame = CGRect.init(x: 0, y: stateLabel.bottom, width: self.width, height: self.height-stateLabel.height)
        }
    }
    override func setStates(_ state: ThHeadRefreshState,oldState : ThHeadRefreshState) {
        super.setStates(state, oldState: oldState)
        if state==oldState{
            return
        }
        self.stateLabel.text = self.stateDict[state.rawValue]
        switch(state){
        case .idle:
            self.timeDate = Date()
            self.arrow.isHidden=false
            self.indicateView.isHidden = true
            self.arrow.transform=CGAffineTransform.identity
            break
        case .pulling:
            self.arrow.isHidden=false
            self.indicateView.isHidden = true
            self.arrow.transform = CGAffineTransform( rotationAngle: CGFloat(-M_PI) )
            break
        case .refreshing:
            self.arrow.isHidden=true
            self.indicateView.isHidden = false
            self.indicateView.startAnimating()
            break
        default:
            break
        }

    }
    func setTitleforState(_ title :String, state : ThHeadRefreshState){
        if title.isEmpty{
            return
        }
        self.stateDict[state.rawValue]=title
        self.stateLabel.text = self.stateDict[state.rawValue]
    }
    var timeDate : Date? {
        didSet{
            if (timeDate == nil){
                self.DataLabel.text = "最后更新：无记录"
                return
            }
            UserDefaults.standard.set(timeDate, forKey: ThHeadRefreshTimeKey)
            UserDefaults.standard.synchronize()
            let calendar = Calendar.current
            let unitFlags : NSCalendar.Unit = [.year,.month,.day,.hour,.minute]
            //创建当前和需要计算的components
            let cmp = (calendar as NSCalendar).components(unitFlags, from: timeDate!)
            let cmpNow = (calendar as NSCalendar).components(unitFlags, from: Date())
            
            let format = DateFormatter()
            if cmp.day==cmp.day{
                format.dateFormat = "今天 HH:mm"
            }else if cmp.year==cmpNow.year{
                format.dateFormat = "MM-dd HH:mm"
            }else {
                format.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let string = format.string(from: timeDate!)
            self.DataLabel.text = string
        }
    }
    var dataKey : String = ThHeadRefreshTimeKey {
        didSet{
            self.timeDate = UserDefaults.standard.object(forKey: dataKey) as? Date
        }
    }
    lazy var stateDict : Dictionary<Int,String> = {
        let staDic = Dictionary<Int , String>()
        return staDic
    }()
    lazy var DataLabel : UILabel = {
        let data = UILabel ()
        self.addSubview(data)
        data.textAlignment = .center
        data.font = UIFont.systemFont(ofSize: 13)
        data.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        return data
    }()
    lazy var stateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()

}
