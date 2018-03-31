//
//  MenuBar.swift
//  First Crush
//
//  Created by Sumit Johri on 23/03/18.
//  Copyright © 2018 Sumit Johri. All rights reserved.
//

import UIKit

class MenuBar:UIView {
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame:CGRect(x: 0,y: 0,width: self.frame.width,height: 60), collectionViewLayout: layout)
        
        //backgroundColor = UIColor.black
        collectionView.backgroundColor=UIColor.black
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
