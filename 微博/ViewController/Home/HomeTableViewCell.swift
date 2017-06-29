//
//  HomeTableViewCell.swift
//  微博
//
//  Created by 王新克 on 2017/6/26.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    let screenw = UIScreen.main.bounds.size.width
    
    var titleLabel : UILabel?
    var sourceLabel : UILabel?
    var replyCountLabel : UILabel?
    var subImage: UIImageView?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        titleLabel = UILabel()
        titleLabel?.frame = CGRect(x: 120, y: 0, width: screenw - 130, height: 60)
        titleLabel?.textColor = UIColor.black
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.numberOfLines=0
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping//按照单词分割换行，保证换行时的单词完整。
        self.addSubview(titleLabel!)
        
        sourceLabel = UILabel()
        sourceLabel?.frame = CGRect(x: 120, y: 65, width: 100, height: 20)
        sourceLabel?.textColor = UIColor.black
        sourceLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(sourceLabel!)
        
        replyCountLabel = UILabel()
        replyCountLabel?.frame = CGRect(x: screenw - 80, y: 65, width: 100, height: 20)
        replyCountLabel?.textColor = UIColor.black
        replyCountLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(replyCountLabel!)
        
    
        subImage = UIImageView()
        subImage?.frame = CGRect(x: 5, y: 5, width: 100, height: 80)
        self.addSubview(subImage!)
    }
    
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
