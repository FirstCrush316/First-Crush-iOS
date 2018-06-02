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

class HomeViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout,WKUIDelegate, WKNavigationDelegate,UITabBarControllerDelegate{
    let videoCellId="videoCellId"
    let tabNames = ["Featured","News","Trailers","Travel"]
    let URL = ["http://www.firstcrush.co","http://www.firstcrush.co/news/","http://www.firstcrush.co/trailers/","http://www.firstcrush.co/travel/"]
    weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing=0
        }
        
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor=UIColor.gray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsetsMake(0,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,0,0)
        collectionView?.isPagingEnabled=true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        let url = NSURL(string: "\(URL[indexPath.item])")
        let request = URLRequest(url: url! as URL)
        cell.webView.load(request)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.height)
    }
}

class VideoCell:UICollectionViewCell, UIScrollViewDelegate, WKNavigationDelegate{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var progressView: UIProgressView!
    var loadSpinner: UIActivityIndicatorView!
    weak var navigationTitle: UINavigationItem!
    
    let webConfiguration = WKWebViewConfiguration()
    @objc var lastOffsetY :CGFloat = 0
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints=false
        return mb
    }()
    
    let view:UIView = {
        let rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=false
        return rootView
    }()
    
    var webView: WKWebView = {
        
        var web=WKWebView()
        
        web.translatesAutoresizingMaskIntoConstraints=false
        return web
    }()
    
    
    func setupViews(){
        backgroundColor=UIColor.gray
        
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        
      //Setup Content View
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        
         //Menu Bar Setup
         let menuBar  = MenuBar(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: 65))
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        
        
        //WebView Setup
        webView = WKWebView(frame:CGRect(x: 0,y: 0,width: frame.width,height: frame.height), configuration: webConfiguration)
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scrollView.backgroundColor = UIColor.clear
        
        webView.allowsLinkPreview=false
        webView.allowsBackForwardNavigationGestures=false
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.contentInset=UIEdgeInsets(top: 65,left: 0,bottom: 0,right: 0)
        //view.backgroundColor=UIColor.black
        //self.webView.isOpaque = false
        //self.webView.backgroundColor = UIColor.clear
        //self.webView.scrollView.backgroundColor = UIColor.clear
        view.addSubview(webView)
        //webView.navigationDelegate = self
        //webView.backgroundColor=UIColor.black
        //webView.autoresizesSubviews=true
        //webView.contentMode = .scaleToFill
        //webView.frame = view.bounds
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.color=UIColor.white
        loadSpinner.center = self.view.center
        webView.addSubview(loadSpinner)
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 68,width: self.view.frame.width,height: self.view.frame.height))
        progressView.backgroundColor=UIColor.black
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        //progressView.sizeToFit()
        webView.addSubview(progressView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backAction(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
            UINavigationBar.appearance().isHidden = true
        }
        else {
            UINavigationBar.appearance().isHidden = true
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack
        {
            lastOffsetY = scrollView.contentOffset.y
            UINavigationBar.appearance().isHidden = false
            
        }
        else {
            UINavigationBar.appearance().isHidden = true
            self.webView.frame = self.view.bounds
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack {
            let hide = scrollView.contentOffset.y > self.lastOffsetY
            UINavigationBar.appearance().isHidden = false
        }
        else {
            UINavigationBar.appearance().isHidden = true
            self.webView.frame = self.view.bounds
        }
    }
    
    func refreshWebView(sender: UIRefreshControl) {
        // On Scroll to Refresh, Reload Current Page
        print("Scroll to Refresh Initiated")
        webView.reload()
        sender.endRefreshing()
    }
    
    //Disable Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil;
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Display Progress Bar While Loading Pages
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        //Display Title
        if (keyPath == "title") {
            //print(webView.title)
            //.navigationItem.title = webView.title
        }
    }
}
