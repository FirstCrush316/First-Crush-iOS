//
//  HomeViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 12/05/18.
//  Copyright © 2018 Sumit Johri. All rights reserved.
//

import Foundation
//
//  MenuBar.swift
//  First Crush
//
//  Created by Sumit Johri on 23/03/18.
//  Copyright © 2018 Sumit Johri. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation;
import MediaPlayer;

class HomeViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let videoCellId="videoCellId"
    let tabNames = ["Featured","News","Trailers","Travel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title="Home"
        collectionView?.backgroundColor=UIColor.darkGray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        cell.wordLabel.text="\(tabNames[indexPath.item])"
        cell.wordLabel.textAlignment = .center
        cell.wordLabel.font = UIFont (name: "Caption 1", size: 40)
        cell.wordLabel.textColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.height)
    }
}

class VideoCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let wordLabel: UILabel = {
        let label = UILabel()
        //label.text = "Featured"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        backgroundColor=UIColor.blue
        wordLabel.textColor=UIColor.red
        addSubview(wordLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
