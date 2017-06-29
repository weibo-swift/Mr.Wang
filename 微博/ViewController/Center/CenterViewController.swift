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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let collectionView =  UICollectionView(frame: CGRect(x: 0, y: ScreenHeight - 120 - 200, width: ScreenWidth, height: 200), collectionViewLayout: LineLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource  = self
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(CenterCollectionViewCell.self, forCellWithReuseIdentifier: "ImageTextCell")
        self.view.addSubview(collectionView)
        
        
        self.setMainUI()
    }

}

extension CenterViewController {
    
    func setMainUI(){
        
        let closeButton : UIButton = {
            
            let closeButton = UIButton()
            closeButton.frame = CGRect(x: (ScreenWidth - 30)/2, y: ScreenHeight - 80, width: 30, height: 30)
            closeButton.backgroundColor = UIColor.red
            closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
            
            return closeButton
        }()
        
        self.view.addSubview(closeButton)
        
    }
    
}


extension CenterViewController {
    
    func close(){
        
        self.dismiss(animated: true, completion: nil)
        
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
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    
}

