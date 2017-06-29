//
//  LineLayout.swift
//  微博
//
//  Created by 王新克 on 2017/6/29.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class LineLayout: UICollectionViewFlowLayout {

    var itemW: CGFloat = 70
    var itemH: CGFloat = 70
    let ScreenWidth = UIScreen.main.bounds.size.width

    
    override init() {
        super.init()
        
        //设置每一个元素的大小
        self.itemSize = CGSize(width: itemW, height: itemH)
        //设置滚动方向
        self.scrollDirection = .horizontal
        //设置间距
        self.minimumLineSpacing = (ScreenWidth - (itemW * 4) - 40)/3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //苹果推荐，对一些布局的准备操作放在这里
    override func prepare() {
        //设置边距(让第一张图片与最后一张图片出现在最中央)ps:这里可以进行优化
//        let inset = (self.collectionView?.bounds.width ?? 0)  * 0.5 - self.itemSize.width * 0.5
        self.sectionInset = UIEdgeInsetsMake(((200 - (itemH * 2) - 30) / 2), 25, ((200 - (itemH * 2) - 30) / 2), 25)
    }
    
}
