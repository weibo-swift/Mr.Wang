//
//  ThHeadBounceRefreshView.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/7.
//  Copyright © 2016年 tanhui. All rights reserved.
//

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


class ThHeadBounceRefreshView: ThHeadRefreshView {
    let l1 = UIView()
    let l2 = UIView()
    let r1 = UIView()
    let r2 = UIView()
    let c = UIView()
    var progress = 0.0
    let KeyPathX = "pathx"
    let KeyPathY = "pathy"
    var focusX : CGFloat?
    var focusY : CGFloat?
    var shapeLayer = CAShapeLayer()
    var circleView = UIView()
    var circleLayer = CAShapeLayer()
    var loadingColor : UIColor? {
        willSet{
            circleLayer.strokeColor = newValue!.cgColor
        }
    }
    var bgColor : UIColor? {
        willSet{
            shapeLayer.fillColor = newValue!.cgColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configeShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:private Methods
    fileprivate func configeCircleLayer(){
        self.circleView.size = CGSize(width: ThHeadRefreshingCircleRadius * 2.0, height: ThHeadRefreshingCircleRadius*2.0)
        circleView.center = self.center
        circleView.backgroundColor=UIColor.clear
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = self.loadingColor?.cgColor
        circleLayer.lineWidth = 3;
        circleLayer.frame = circleView.bounds
        
        self.circleView.layer.addSublayer(circleLayer)
        self.addSubview(circleView)
    }
    fileprivate func configeShapeLayer(){
        shapeLayer.frame = self.bounds
        self.layer.addSublayer(shapeLayer)
    }
    fileprivate func updateShapeLayerPath (){
        let bezierPath = UIBezierPath()
        if(self.height<=self.oringalheight){
            let lControlPoint1 = CGPoint(x:0,y:self.oringalheight!)
            let lControlPoint2 = CGPoint(x:0,y:self.oringalheight!)
            
            let rControlPoint1 = CGPoint(x:self.width,y:self.oringalheight!)
            let rControlPoint2 = CGPoint(x:self.width,y:self.oringalheight!)
            
            l1.center = lControlPoint1
            l2.center = lControlPoint2
            r1.center = rControlPoint1
            r2.center = rControlPoint2
            c.center = CGPoint(x:self.width*0.5 , y:self.oringalheight!)
            
            bezierPath .move(to: CGPoint(x: 0, y: 0))
            bezierPath .addLine(to: CGPoint(x:self.width, y: 0))
            bezierPath .addLine(to: rControlPoint1)
            bezierPath.addLine(to: lControlPoint1)
            bezierPath.addLine(to: CGPoint(x: 0, y: 0))
            bezierPath.close()
        }else{
            self.focusY = self.height
            let rate :CGFloat = 0.75
            let marginHeight = ( self.height - self.oringalheight! ) * 0.3 + self.oringalheight!
            let controlHeight = ( self.height - self.oringalheight! ) * 1 + self.oringalheight!
            let leftWidth = self.focusX!
            let rightWidth = self.width - self.focusX!
            
            let lControlPoint1 = CGPoint(x:leftWidth*rate ,y:marginHeight)
            let lControlPoint2 = CGPoint(x:leftWidth * rate,y:controlHeight)
            
            let rControlPoint1 = CGPoint(x:rightWidth*(1-rate)+leftWidth,y:marginHeight)
            let rControlPoint2 = CGPoint(x:rightWidth*(1-rate)+leftWidth,y:controlHeight)
            
            l1.center = lControlPoint1
            l2.center = lControlPoint2
            r1.center = rControlPoint1
            r2.center = rControlPoint2
            c.center = CGPoint(x:leftWidth , y:self.focusY!)
            bezierPath .move(to: CGPoint(x: 0, y: 0))
            bezierPath .addLine(to: CGPoint(x:self.width, y: 0))
            bezierPath .addLine(to: CGPoint(x: self.width,y: marginHeight))
            
            bezierPath.addCurve(to: CGPoint(x: leftWidth+1,y: self.focusY!), controlPoint1: rControlPoint1, controlPoint2: rControlPoint2)
            bezierPath.addLine(to: CGPoint(x:leftWidth-1 , y:self.focusY!))
            bezierPath.addCurve(to: CGPoint(x: 0,y: marginHeight), controlPoint1: lControlPoint2, controlPoint2: lControlPoint1)
            
            bezierPath.close()
        }
        
        shapeLayer.path = bezierPath.cgPath
    }
    func updateCirclePath(){
        circleView.centerY = self.height*0.5
        circleView.centerX = self.centerX
        if self.state == .pulling||self.state == .idle{
            let loadingBezier = UIBezierPath()
            let center = CGPoint(x: circleView.width*0.5, y: circleView.height*0.5)
            loadingBezier.addArc(withCenter: center, radius: ThHeadRefreshingCircleRadius , startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2) * progress - M_PI_2) , clockwise: true)
            circleLayer.path = loadingBezier.cgPath
        }else if(self.state == .refreshing){
            //刷新的动画
            if(circleLayer.animation(forKey: "refreshing") != nil){
                return
            }
            let loadingBezier = UIBezierPath()
            let center = CGPoint(x: circleView.width*0.5, y: circleView.height*0.5)
            loadingBezier.addArc(withCenter: center, radius: ThHeadRefreshingCircleRadius , startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2) * 0.9 - M_PI_2) , clockwise: true)
            circleLayer.path = loadingBezier.cgPath
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.byValue = M_PI_2*3
            animate.repeatCount=999
            animate.duration = 0.5
            animate.fillMode = kCAFillModeForwards
            circleLayer.add(animate, forKey: "refreshing")
        }
    }
    
    fileprivate func removePath(){
        if circleLayer.path != nil{
            circleLayer.removeAnimation(forKey: "refreshing")
            circleLayer.path = nil
        }
    }
    fileprivate func startAnimating(){
        if(self.displayLink == nil){
            displayLink = CADisplayLink(target: self, selector: #selector(ThHeadBounceRefreshView.updateCirclePath))
            displayLink!.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
    }
    fileprivate func stopAnimating(){
        displayLink?.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        displayLink?.isPaused = true
        displayLink = nil
        if circleLayer.path != nil{
            circleLayer.removeAnimation(forKey: "refreshing")
            circleLayer.path = nil
        }
    }
//MARK:Overrides
    override func setStates(_ state: ThHeadRefreshState,oldState : ThHeadRefreshState) {
        super.setStates(state, oldState: oldState)
        if state==oldState{
            return
        }
        switch(state){
        case .refreshing:
            self.startAnimating()
                break;
        case .idle:
            if oldState == .refreshing{
                self.stopAnimating()
                self.removePath()
            }
            break
        default:
            break
        }
        
    }
    override func adjustStateWithContentOffset(){
        if self.state == .refreshing&&self.scrollView?.isDragging==true{
            if( self.scrollView?.th_offsetY < 0-(self.scrollView?.th_insetT)! ){
                self.scrollView?.th_offsetY = -(self.scrollView?.th_insetT)!
            }
        }
        progress = Double( (self.height-self.oringalheight!)/self.oringalheight!)
        if(self.scrollView?.isDragging == true){
            self.startAnimating()
            if(self.state == .idle && progress>0.9){
                self.state = .pulling
            }else if (self.state == .pulling && progress<=0.9){
                self.state = .idle
            }
        }else if (self.state == .pulling){
            self.state = .refreshing
//            self.stopAnimating()
//            self.startAnimating()
        }else if(self.state == .idle){
            self.stopAnimating()
            self.removePath()
        }
        
        let offY = 0 - Double((self.scrollView?.th_offsetY)!)
        let culheight = (self.scrollView?.th_insetT)!+self.oringalheight!
        if (offY > Double( culheight )){
            if(self.scrollView?.isDragging==true||self.state == .idle){
                self.height = CGFloat( offY - Double((self.scrollView?.th_insetT)!) )
                let pan = self.scrollView?.panGestureRecognizer
                let point = pan?.location(in: self)
                self.focusX = point?.x
                if(self.scrollView?.isDragging==true){
                    self.startAnimating()
                }
            }
        }else if(self.state == .refreshing||self.state == .idle){
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.height = self.oringalheight!;
            })
        }
        
        self.layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShapeLayerPath()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if (newSuperview != nil){
            //initial circleView after self
            self.configeCircleLayer()
            
            self.focusX = self.width * 0.5
            self.focusY = self.oringalheight
            shapeLayer.frame = self.bounds
            self.addObserver(self, forKeyPath: KeyPathX, options: .new, context: nil)
            self.addObserver(self, forKeyPath: KeyPathY, options: .new, context: nil)
            
            self.l1.size = CGSize(width: 3, height: 3)
            self.l2.size = CGSize(width: 3, height: 3)
            self.r1.size = CGSize(width: 3, height: 3)
            self.r2.size = CGSize(width: 3, height: 3)
            c.size = CGSize(width: 3, height: 3)
            
            l1.backgroundColor = UIColor.clear
            l2.backgroundColor = UIColor.clear
            r1.backgroundColor = UIColor.clear
            r2.backgroundColor = UIColor.clear
            c.backgroundColor = UIColor.clear

            self.addSubview(l1)
            self.addSubview(l2)
            self.addSubview(r1)
            self.addSubview(r2)
            self.addSubview(c)

        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == KeyPathX || keyPath == KeyPathY){
        }else if keyPath == ThHeadRefreshContentOffset {
            self.adjustStateWithContentOffset()
        }
    }

    deinit{
        self.removeObserver(self, forKeyPath: KeyPathX, context: nil)
        self.removeObserver(self, forKeyPath: KeyPathY, context: nil)
    }
    var displayLink : CADisplayLink?
}
