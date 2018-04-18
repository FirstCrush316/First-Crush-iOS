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
        let collectionView = UICollectionView(frame:CGRect(x: 0,y: 0,width: self.frame.width,height: 60), collectionViewLayout: layout)
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
        cell.wordLabel.text="\(tabNames[indexPath.item])"
        cell.wordLabel.textAlignment = .center
        cell.wordLabel.font = UIFont (name: "Caption 1", size: 20)
        cell.wordLabel.textColor = UIColor.white
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
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "HOME"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupViews() {
        //addSubview(textView!)
        backgroundColor = UIColor.black;
        addSubview(wordLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
        /*wordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true*/
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
