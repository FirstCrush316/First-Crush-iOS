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
    var homeController:HomeViewController?
    
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
        collectionView?.backgroundColor=UIColor.darkGray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsetsMake(0,0,0,0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(65,0,0,0)
        collectionView?.isPagingEnabled=true
        
        //Root View Setup
        view.addSubview(menuBarHome)
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBarHome]))
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBarHome]))
        //menuBarHome.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0.0)
        menuBarHome.translatesAutoresizingMaskIntoConstraints=true
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
       /* if webView.canGoBack {
            webView.goBack()
            UINavigationBar.appearance().isHidden = true
        }
        else {*/
            UINavigationBar.appearance().isHidden = false
        //}
    }
  
    @IBAction func refreshAction(_ sender: Any) {
        //progressView.isHidden = false
        collectionView?.reloadData();
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
        cell.invalidateIntrinsicContentSize()
        //cell.setNeedsLayout()
        cell.setupViews()
        cell.webView.load(request)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBarHome.horizontalBarLeftAnchorConstraint?.constant=scrollView.contentOffset.x / 4
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y<0{
            UINavigationBar.appearance().isHidden = false
        }
        else {
            UINavigationBar.appearance().isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            UIApplication.shared.isStatusBarHidden = true // Landscape
        } else {
            UIApplication.shared.isStatusBarHidden = false //Portrait
        }
        collectionView?.collectionViewLayout.invalidateLayout()
        setupCollectionView()
        collectionView?.reloadData()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(targetContentOffset.pointee.x);
        print(view.frame.width)
        let index = round((targetContentOffset.pointee.x)/view.frame.width)
        print(index)
        //let indexPath = NSIndexPath(item: index), section: 0)
        //scrollToMenuIndex(menuIndex: Int(index))
        //menuBarHome.collectionView(UICollectionView, shouldSelectItemAt: indexPath)
        //self.collectionView?.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        //let indexPath = NSIndexPath(item: menuIndex, section: 0)
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBarHome.collectionView(collectionView!, didSelectItemAt: indexPath as IndexPath)
        
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
    
    let webConfiguration = WKWebViewConfiguration()
    @objc var lastOffsetY :CGFloat = 0
    
    var view:UIView = {
        var rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=true
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
        view.translatesAutoresizingMaskIntoConstraints=true
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":view]))
        
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
        webView.translatesAutoresizingMaskIntoConstraints=true
        webView.scrollView.contentInset=UIEdgeInsets(top: 65,left: 0,bottom: 0,right: 0)
        
        //Add WebView
        view.addSubview(webView)
        
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(65)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view=webView
        
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.color=#colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        loadSpinner.center = self.view.center
        webView.addSubview(loadSpinner)
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 65,width: self.view.frame.width,height: self.view.frame.height))
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
                /*if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController")  as? DetailViewController {
                 vc.detailURL = navigationAction.request.url! as NSURL
                 vc.webConfiguration = webConfiguration
                 //wv = vc.webView as? WKWebView
                 
                 self.navigationController?.pushViewController(vc, animated: true)
                 //self.performSegue(withIdentifier: "detailView", sender: webView.url!)
                 }*/
                
            }
        default:
            break
        }
        decisionHandler(.allow)
    }
    
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
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
     if let detailViewController = segue.destination as? DetailViewController{
     if let detailURL = sender as? NSURL{
     detailViewController.detailURL = detailURL
     }
     }
     }*/
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "detailView") {
            let navigationController = segue.destination as! UINavigationController
            let detailViewController = navigationController.topViewController as! DetailViewController
            detailViewController.detailURL=sender as! NSURL
        }
    }
    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
     {
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 4 {
            //self.window?.rootViewController?.present(HomeViewController, animated: true, completion: nil)
            //navigationController?.setNavigationBarHidden(true, animated: true)
            //let tabBarController: TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(withIdentifier: "TabBarController") as! TabBarController
            webView.reloadFromOrigin()
            lastOffsetY = 0
        }
        
    }

}
