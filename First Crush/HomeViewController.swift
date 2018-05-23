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
    let URL = ["http://www.firstcrush.co","http://www.firstcrush.co/news/","http://www.firstcrush.co/trailers/","http://www.firstcrush.co/travel/"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing=0
        }
        
        setupCollectionView()
        setupMenuBar()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor=UIColor.darkGray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsetsMake(65,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(65,0,0,0)
        collectionView?.isPagingEnabled=true
    }
    
   
    
    func setupMenuBar(){
       
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
        let url = NSURL(string: "\(URL[indexPath.item])")
        let request = URLRequest(url: url! as URL)
        cell.webView.load(request)
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
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints=false
        return mb
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        //label.text = "Featured"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let view:UIView = {
        let rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=false
        return rootView
    }()
    
    let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints=false
        return web
    }()
    
    func setupViews(){
        backgroundColor=UIColor.darkGray
        wordLabel.textColor=UIColor.red
        //addSubview(wordLabel)
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        view.addSubview(webView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        webView.addSubview(menuBar)
        
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        menuBar.topAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
