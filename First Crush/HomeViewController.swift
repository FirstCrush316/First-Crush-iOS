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
    
    var homeController:HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.sectionInset = UIEdgeInsets (top: 20, left: 0, bottom: 0, right: 0)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing=0
            collectionView = UICollectionView(frame:self.view.frame, collectionViewLayout: flowLayout)
            collectionView?.dataSource=self
            collectionView?.delegate=self
            collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
            self.view.addSubview(collectionView!)
        }
        
        //Menu Bar Setup
        menuBar  = MenuBar(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: 42))
        menuBar.contentMode = .scaleToFill
        menuBar.homeController=self
        
        setupCollectionView()
    }
    
    func setupCollectionView(){
        
        collectionView?.backgroundColor=UIColor.darkGray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsetsMake(0,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(42,0,0,0)
        collectionView?.isPagingEnabled=true
        //collectionView?.isPrefetchingEnabled=true
        //self.automaticallyAdjustsScrollViewInsets=true
        //self.view.translatesAutoresizingMaskIntoConstraints=false
        
        //Root View Setup
        //view.addSubview(navBar)
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(42)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0.0)
        //view.translatesAutoresizingMaskIntoConstraints=false
        menuBar.translatesAutoresizingMaskIntoConstraints=false
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: (indexPath as IndexPath), at: [], animated: true)
        
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
        cell.backgroundColor=UIColor.blue
        cell.webView.load(request)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant=scrollView.contentOffset.x / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
        //collectionView?.setNeedsLayout()
        //menuBar.setNeedsLayout()
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Inside Segue Collection View")
        let newVC = UIViewController()
        newVC.view.backgroundColor=UIColor.red
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            //UIApplication.shared.isStatusBarHidden = true // Landscape
            //self.view.inputViewController?.preferredStatusBarStyle = .true
            menuBar.homeController?.loadViewIfNeeded()
            
        } else {
            //UIApplication.shared.isStatusBarHidden = false //Portrait
            ///self.view.inputViewController?.prefersStatusBarHidden = false//
            menuBar.homeController?.loadViewIfNeeded()
        }
        collectionView?.collectionViewLayout.invalidateLayout()
        self.view.invalidateIntrinsicContentSize()
        self.view.setNeedsDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailView") {
            let navigationController = segue.destination as! UINavigationController
            let detailViewController = navigationController.topViewController as! DetailViewController
            detailViewController.detailURL=sender as? NSURL
        }
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("Inside Did Select Item")
        performSegue(withIdentifier: "detailView", sender: indexPath)
    }*/
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(targetContentOffset.pointee.x);
        print(view.frame.width)
        let index = round((targetContentOffset.pointee.x)/view.frame.width)
        print(index)
        //let indexPath = NSIndexPath(item: index), section: 0)
        //scrollToMenuIndex(menuIndex: Int(index))
        
        //let indexPath = NSIndexPath(item: menuIndex, section: 0)
        //let indexPath = NSIndexPath(item: Int(index), section: 0)
        //Buggy line
        //collectionView?.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        let selectedIndexPath = IndexPath(item: Int(index), section: 0)
        self.collectionView?.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 4 {
            //self.window?.rootViewController?.present(HomeViewController, animated: true, completion: nil)
            //navigationController?.setNavigationBarHidden(true, animated: true)
            //let tabBarController: TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(withIdentifier: "TabBarController") as! TabBarController
            collectionView?.reloadData()
        }
        
    }
}
class VideoCell:UICollectionViewCell, UIScrollViewDelegate, WKNavigationDelegate,WKUIDelegate, UITabBarControllerDelegate{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var progressView: UIProgressView!
    var loadSpinner: UIActivityIndicatorView!
    weak var navigationTitle: UINavigationItem!
     var homeController:HomeViewController?
    var navBar: UINavigationBar!
    var navItem = UINavigationItem(title: "First Crush")
    
    let webConfiguration = WKWebViewConfiguration()
    @objc var lastOffsetY :CGFloat = 0
    
    var view:UIView = {
        var rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=true
        rootView.contentMode = .scaleToFill
        return rootView
    }()
    
    var webView: WKWebView = {
        
        var web=WKWebView()
        web.translatesAutoresizingMaskIntoConstraints=true
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
        view.backgroundColor=UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints=false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        
        //Setup Nav Bar
        navBar = UINavigationBar(frame: CGRect(x:0, y:42, width: frame.width, height:40))
        navBar.backgroundColor = UIColor.black
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        //let navFont = UIFont(name:"Caption", size: 10)
        //navBar.titleTextAttributes = [NSAttributedStringKey.font: navFont!]
         //navItem = UINavigationItem(title: "First Crush")
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: Selector(("refreshAction")))
        let backItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: Selector(("backAction")))
        
        refreshItem.tintColor=UIColor.white
        backItem.tintColor=UIColor.white
        
        navItem.leftBarButtonItem = backItem
        navItem.rightBarButtonItem = refreshItem
        navBar.setItems([navItem], animated: true)
        navBar.isHidden=true
        navBar.translatesAutoresizingMaskIntoConstraints=true
        
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
        webView.translatesAutoresizingMaskIntoConstraints=false
        webView.scrollView.contentInset=UIEdgeInsets(top: 40,left: 0,bottom: 0,right: 0)
        webView.contentMode = .scaleToFill
        
        //Add WebView
        webView.addSubview(navBar)
        //view.addSubview(navBar)
        view.addSubview(webView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view=webView
       
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.color=#colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        loadSpinner.center = self.view.center
        loadSpinner.translatesAutoresizingMaskIntoConstraints=true
        webView.addSubview(loadSpinner)
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 47,width: self.view.frame.width,height: self.view.frame.height))
        progressView.backgroundColor=UIColor.black
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        progressView.translatesAutoresizingMaskIntoConstraints=true
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
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //let request = webView.url?.absoluteString
        if webView.canGoBack
        {
            lastOffsetY = scrollView.contentOffset.y
            navBar.isHidden=false
            homeController?.menuBar.isHidden=true
            
        }
        else {
            navBar.isHidden=true
            homeController?.menuBar.isHidden=false
            //self.webView.frame = self.view.bounds
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack {
            if(scrollView.contentOffset.y > self.lastOffsetY)
            {
                navBar.isHidden = true
        }
        else {
            navBar.isHidden = false
            //self.webView.frame = self.view.bounds
        }
    }
    }
    
    /*@objc public func getWebView()
    {
        return webView
    }*/
  
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
            print(webView.title!)
            navItem.title = webView.title!
            //navItem = UINavigationItem(title: webView.title!)
            //navBar.topItem?.title="Testing"
        }
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.setProgress(0.1, animated: false)
        progressView.isHidden = false
        loadSpinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.progressView.setProgress(1.0, animated: true)
        progressView.isHidden = true
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                //self.webView.load(navigationAction.request)// It will load that link in same WKWebView
                UIApplication.shared.open(navigationAction.request.url!,options: [:], completionHandler: nil)
            }
            else
            {
                print("Inside Segue Web View")
                
                let newVC = UIViewController()
                newVC.view.backgroundColor=UIColor.red
                homeController?.navigationController?.pushViewController(newVC, animated: true)
                //self.inputViewController?.navigationController?.pushViewController(newVC, animated: true)
                /*let vc = DetailViewController()
                    vc.detailURL = navigationAction.request.url! as NSURL
                    vc.webConfiguration = webConfiguration
                    //let wv = vc.webView as? WKWebView
                
                let viewController = self.inputViewController?.storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
                self.inputViewController?.navigationController?.pushViewController(viewController!, animated: true)
                self.inputViewController?.performSegue(withIdentifier: "detailView", sender: vc.detailURL)*/
                    /*self.inputViewController?.navigationController?.pushViewController(vc, animated: true)
                    self.inputViewController?.performSegue(withIdentifier: "detailView", sender: navigationAction.request.url!)
                print (navigationAction.request.url!)
                //self.inputViewController?.performSegue(withIdentifier: "detailView", sender: navigationAction.request.url!)
                    //self.inputViewController?.navigationController?.pushViewController(vc, animated: true)*/
                
            }
        default:
            break
        }
        decisionHandler(.allow)
    }
    
    @objc func backAction(_ sender: Any) {
        print("Back Button Selected")
        if webView.canGoBack {
            webView.goBack()
            navBar.isHidden=false
            
        }
        else {
            navBar.isHidden=true
        }
    }
    
    @objc func refreshAction(_ sender: Any) {
        print("Refresh selected")
        progressView.isHidden = false
        webView.reload()
    }
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("Inside Prepare for Segue")
        print(segue.identifier!)
        if (segue.identifier == "detailView") {
            let navigationController = segue.destination as! UINavigationController
            let detailViewController = navigationController.topViewController as! DetailViewController
            detailViewController.detailURL=sender as? NSURL
        }
    }
    
    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
     {print("Inside Prepare for Segue")
     if let detailViewController = segue.destination as? DetailViewController{
     if let detailURL = sender as? NSURL{
     //detailViewController.detailURL = easyURLStart
     detailViewController.setdetailURL(detailURL)
     detailViewController.loadView()
     detailViewController.viewDidLoad()
     let request = URLRequest(url: detailURL as URL)
     detailViewController.webView.load(request)
     }
     }
     }*/
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        if Reachability.isConnectedToNetwork() == false {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            self.progressView.setProgress(1.0, animated: true)
            progressView.isHidden = true
            loadSpinner.stopAnimating()
        }
    }
}
