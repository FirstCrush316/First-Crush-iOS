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
    var menuBarHome = MenuBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing=0
        }
        
        //Menu Bar Setup
        menuBarHome  = MenuBar(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: 65))
        menuBarHome.homeController=self
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor=UIColor.gray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsetsMake(0,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(65,0,0,0)
        collectionView?.isPagingEnabled=true
        
        //Root View Setup
        let homeView = UIView()
        view.addSubview(homeView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":homeView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":homeView]))
        
        
        homeView.addSubview(menuBarHome)
        homeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBarHome]))
        homeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBarHome]))
        menuBarHome.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0.0)
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBarHome.horizontalBarLeftAnchorConstraint?.constant=scrollView.contentOffset.x / 4
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
    
    var view:UIView = {
        var rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=false
        return rootView
    }()
    
    var webView: WKWebView = {
        
        var web=WKWebView()
        
        web.translatesAutoresizingMaskIntoConstraints=false
        return web
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews(){
        backgroundColor=UIColor.black
        
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        
      //Setup Content View
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        
        //WebView Setup
        webView = WKWebView(frame:CGRect(x: 0,y: 0,width: frame.width,height: frame.height), configuration: webConfiguration)
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.black
        self.webView.scrollView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        
        webView.allowsLinkPreview=false
        webView.allowsBackForwardNavigationGestures=false
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.contentInset=UIEdgeInsets(top: 65,left: 0,bottom: 0,right: 0)
        
        //Add WebView
        view.addSubview(webView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view=webView
        
        
        
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.color=#colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        loadSpinner.center = self.view.center
        webView.addSubview(loadSpinner)
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 66,width: self.view.frame.width,height: self.view.frame.height))
        progressView.backgroundColor=UIColor.black
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        //progressView.sizeToFit()
        webView.addSubview(progressView)
        
        
        // Implement Scroll to Refresh
        if Reachability.isConnectedToNetwork() == true {
        let refreshControl = UIRefreshControl(frame:(CGRect(x: 0,y: 10,width: self.view.frame.width, height: 15)))
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull To Refresh")
        refreshControl.attributedTitle=NSAttributedString(string: title)
        refreshControl.tintColor=UIColor.white
        refreshControl.backgroundColor=UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(VideoCell.refreshWebView), for: UIControlEvents.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }
    else {
        let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
            })
            alertController.addAction(defaultAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
        webView.scrollView.delegate = self
        lastOffsetY = 0.0
        
        
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
    func scrollViewDidScroll(_ scrollView: UIScrollView){
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack {
            if(scrollView.contentOffset.y > self.lastOffsetY)
            {
                UINavigationBar.appearance().isHidden = false
        }
        else {
            UINavigationBar.appearance().isHidden = true
            self.webView.frame = self.view.bounds
        }
    }
    }
    
    @objc func refreshWebView(sender: UIRefreshControl) {
        // On Scroll to Refresh, Reload Current Page
        print("Scroll to Refresh Initiated")
        webView.reload()
        sender.endRefreshing()
    }
    
    //Disable Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil;
    }
        
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.progressView.setProgress(1.0, animated: true)
        progressView.isHidden = true
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.setProgress(0.1, animated: false)
        progressView.isHidden = false
        loadSpinner.startAnimating()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 4 {
            //self.window?.rootViewController?.present(HomeViewController, animated: true, completion: nil)
            let url = NSURL(string: "http://www.firstcrush.co")
            let request = URLRequest(url: url! as URL)
            webView.load(request)
            //navigationController?.setNavigationBarHidden(true, animated: true)
            lastOffsetY = 0
        }
        
    }

}
