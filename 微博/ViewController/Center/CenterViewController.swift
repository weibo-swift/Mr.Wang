//
//  CenterViewController.swift
//  微博
//
//  Created by 王新克 on 2017/6/29.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

class CenterViewController: UIViewController {

    lazy var imageArray: [String] = {
        
        var array: [String] = ["d_aini","d_aoteman","d_baibai","d_beishang","d_bishi","d_chanzui","d_chijing","d_duixiang","d_guzhang","d_haixiu","d_huaxin","d_madaochenggong","d_qian","d_taikaixin","f_shenma"]
        
        return array
    }()
    
    lazy var pageControl = UIPageControl()
    lazy var collectionView =  UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "new_feature_1")!)
        
        self.setCollectionView()
        self.setPageController()
        self.setMainUI()
    }

}

extension CenterViewController {
    
    fileprivate func setMainUI(){
        
        let closeButton : UIButton = {
            
            let closeButton = UIButton()
            closeButton.frame = CGRect(x: (ScreenWidth - 30)/2, y: ScreenHeight - 40, width: 30, height: 30)
            closeButton.setImage(UIImage(named: "common_icon_membership"), for: .normal)
            closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
            
            return closeButton
        }()
        
        self.view.addSubview(closeButton)
        
    }
    
    fileprivate func setCollectionView(){
        
        collectionView =  UICollectionView(frame: CGRect(x: 0, y: ScreenHeight - 120 - 200, width: ScreenWidth, height: 200), collectionViewLayout: LineLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource  = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(CenterCollectionViewCell.self, forCellWithReuseIdentifier: "ImageTextCell")
    
        self.view.addSubview(collectionView)
    }
    
    fileprivate func setPageController(){
        
        pageControl = UIPageControl.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2, height: 30))
        pageControl.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 120)
        pageControl.backgroundColor = UIColor.clear
        // 其他属性设置
        pageControl.numberOfPages = 2 // 总页数
        pageControl.currentPage = 0 // 当前页数，默认为0，即第一个，实际数量是0~n-1
        pageControl.pageIndicatorTintColor = UIColor.gray // 非当前页颜色
        pageControl.currentPageIndicatorTintColor = UIColor.black // 当前页颜色
        
        pageControl.addTarget(self, action: #selector(nextPageView), for: .touchUpInside)
        
        self.view.addSubview(pageControl);
        
    }
    
}


extension CenterViewController {
    
   @objc fileprivate func close(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc fileprivate func nextPageView(){
        
        let page = self.pageControl.currentPage
        // 设置偏移量
        let offsetX = CGFloat(page) * ScreenWidth
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        self.pageControl.currentPage = page
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }
    
}

extension CenterViewController : UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextCell", for: indexPath) as! CenterCollectionViewCell
        cell.imageStr = self.imageArray[indexPath.item] as NSString

        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = (scrollView.contentOffset.x / ScreenWidth) + 0.5
        pageControl.currentPage = Int(page)
    }
}

