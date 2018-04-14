//
//  MenuBar.swift
//  First Crush
//
//  Created by Sumit Johri on 23/03/18.
//  Copyright © 2018 Sumit Johri. All rights reserved.
//

import UIKit

class MenuBar:UIView , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    let cellId="cellId"
    let tabNames = ["Home","News","Trailers","Travel"]

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame:CGRect(x: 0,y: 0,width: self.frame.width,height: 50), collectionViewLayout: layout)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        //backgroundColor = UIColor.black
        collectionView.backgroundColor=UIColor.black
        collectionView.dataSource=self
        collectionView.delegate=self
        
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        //cell.backgroundColor=UIColor.blue
        
        //cell.textView.text=tabNames[indexPath.item]
        //print("Cell Text",cell.textView.text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell:UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    var textView:UITextView!
    
    func setupViews() {
        //textView.text="Home"
        //addSubview(textView)
        backgroundColor = UIColor.yellow;
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(20)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":textView]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(20)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":textView]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
