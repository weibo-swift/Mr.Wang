//
//  CenterCollectionViewCell.swift
//  微博
//
//  Created by 王新克 on 2017/6/29.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class CenterCollectionViewCell: UICollectionViewCell {
   
    var imageView: UIImageView?
    var imageStr: NSString? {
        
        didSet {
            self.imageView!.image = UIImage(named: self.imageStr! as String)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.addSubview(self.imageView!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: (self.frame.size.width - 32) / 2, y: (self.frame.size.height - 32) / 2, width: 32, height: 32)
        self.imageView?.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
