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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing=0
            collectionView = UICollectionView(frame:self.view.frame, collectionViewLayout: flowLayout)
            collectionView?.dataSource=self
            collectionView?.delegate=self
            collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
            view.addSubview(collectionView!)
            collectionView?.translatesAutoresizingMaskIntoConstraints=false
            collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive=true
            collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0).isActive=true
            collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0.0).isActive=true
            collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0.0).isActive=true
            collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0.0).isActive=true
            self.tabBarController?.delegate = self
        }
        
        //Menu Bar Setup
        menuBar  = MenuBar(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: 45))
        menuBar.homeController=self
        setupCollectionView()
    }
    
    func setupCollectionView(){
        
        collectionView?.backgroundColor=UIColor.darkGray
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "videoCellId")
        collectionView?.contentInset = UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets.init(top: 45,left: 0,bottom: 0,right: 0)
        collectionView?.isPagingEnabled=true
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        //collectionView?.isPrefetchingEnabled=true
        //self.automaticallyAdjustsScrollViewInsets=true
        //self.view.translatesAutoresizingMaskIntoConstraints=false
        
        //Root View Setup
        //view.addSubview(navBar)
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints=false
        collectionView?.translatesAutoresizingMaskIntoConstraints=false
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(45)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        menuBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive=true
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0).isActive=true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0.0).isActive=true
        menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0.0).isActive=true
        menuBar.heightAnchor.constraint(equalToConstant: 45).isActive=true
        //menuBar.isHidden=true
        
    }
    
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: (indexPath as IndexPath), at: [], animated: true)
        
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        mb.translatesAutoresizingMaskIntoConstraints=false
        return mb
    }()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
        cell.contentView.frame=cell.bounds
        cell.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let url = NSURL(string: "\(URL[indexPath.item])")
        let request = URLRequest(url: url! as URL)
        cell.webView.load(request)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.invalidateLayout()
        
        let indexPath = collectionView.indexPathsForVisibleItems.first
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
            self.collectionView?.setNeedsLayout()
        }
        cell.prepareForReuse()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.invalidateLayout()
        
        let indexPath = collectionView?.indexPathsForVisibleItems.first
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
            self.collectionView?.setNeedsLayout()
        }
    }
    
    func getMenuBar() -> MenuBar
    {
        return menuBar
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.invalidateLayout()
        
        let indexPath = collectionView?.indexPathsForVisibleItems.first
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: true)
            self.collectionView?.setNeedsLayout()
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailView") {
            let navigationController = segue.destination as! UINavigationController
            let detailViewController = navigationController.topViewController as! DetailViewController
            detailViewController.detailURL=sender as? NSURL
        }
    }*/
    
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("Inside Did Select Item")
        performSegue(withIdentifier: "detailView", sender: indexPath)
    }*/
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant=scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //print(targetContentOffset.pointee.x);
        //print(view.frame.width)
        let index = round((targetContentOffset.pointee.x)/view.frame.width)
        //print(index)
        let selectedIndexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
       // print ("Tab Index", tabBarIndex)
        if tabBarIndex == 0 {
            //self.rootViewController?.present(homeController!, animated: true, completion: nil)
            //navigationController?.setNavigationBarHidden(true, animated: true)
            //let tabBarController: TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(withIdentifier: "TabBarController") as! TabBarController
            collectionView?.reloadData()
        
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
    @objc var lastOffsetX :CGFloat = 0
    
    var view:UIView = {
        var rootView = UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=false
        rootView.contentMode = .scaleAspectFit
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
        view.backgroundColor=UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints=false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive=true
        view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0).isActive=true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:0.0).isActive=true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:0.0).isActive=true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        
        
        
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
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        } else {
            
        }
        webView.translatesAutoresizingMaskIntoConstraints=false
        //webView.scrollView.contentInset=UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        webView.contentMode = .scaleAspectFit
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        
        //Setup Nav Bar
        navBar = UINavigationBar(frame: CGRect(x:0, y:45, width: frame.width, height:45))
        navBar.backgroundColor = UIColor.black
        //print(UIFont.familyNames)
        let navFont = UIFont.preferredFont(forTextStyle: .caption1) //UIFont(name:"Baskerville", size: 15)
        navBar.titleTextAttributes = [NSAttributedString.Key.font: navFont, NSAttributedString.Key.foregroundColor : UIColor.white]
        navItem = UINavigationItem(title: "First Crush")
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        let backItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backAction))
        
        refreshItem.tintColor=UIColor.white
        backItem.tintColor=UIColor.white
        
        navItem.leftBarButtonItem = backItem
        navItem.rightBarButtonItem = refreshItem
        navBar.setItems([navItem], animated: true)
        navBar.isHidden=true
        navBar.translatesAutoresizingMaskIntoConstraints=false
        
        
        
        
        //view.addSubview(navBar)
        view.addSubview(webView)
        
        
        
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 45.0).isActive=true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0).isActive=true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0.0).isActive=true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0.0).isActive=true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        view=webView
        
        //Add NavBar
        webView.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo:webView.topAnchor, constant: 0.0).isActive=true
        navBar.widthAnchor.constraint(equalTo: webView.widthAnchor, constant: 0.0).isActive=true
        navBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor,constant:0.0).isActive=true
        navBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor,constant:0.0).isActive=true
        navBar.heightAnchor.constraint(equalToConstant:45.0).isActive=true
        
        
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.style=UIActivityIndicatorView.Style.whiteLarge
        loadSpinner.color=#colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        loadSpinner.center = self.view.center
        loadSpinner.translatesAutoresizingMaskIntoConstraints=false
        webView.addSubview(loadSpinner)
        loadSpinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor,constant:0.0).isActive=true
        loadSpinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor,constant:0.0).isActive=true
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 47,width: self.view.frame.width,height: self.view.frame.height))
        progressView.backgroundColor=UIColor.black
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        progressView.translatesAutoresizingMaskIntoConstraints=false
        //progressView.sizeToFit()
        webView.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo:webView.topAnchor, constant: 1.0).isActive=true
        progressView.widthAnchor.constraint(equalTo: webView.widthAnchor, constant: 0.0).isActive=true
        progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor,constant:0.0).isActive=true
        progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor,constant:0.0).isActive=true
        
        
        // Implement Scroll to Refresh
        if Reachability.isConnectedToNetwork() == true {
        let refreshControl = UIRefreshControl(frame:(CGRect(x: 0,y: 10,width: self.view.frame.width, height: 15)))
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull To Refresh")
        refreshControl.attributedTitle=NSAttributedString(string: title)
        refreshControl.tintColor=UIColor.white
        refreshControl.backgroundColor=UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(VideoCell.refreshWebView), for: UIControl.Event.valueChanged)
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
        lastOffsetX = 0.0
        lastOffsetY = 0.0
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let request = webView.url?.absoluteString
        if (webView.canGoBack && request != "https://www.firstcrush.co/")
        {
            lastOffsetX = scrollView.contentOffset.x
            lastOffsetY = scrollView.contentOffset.y
            navBar.isHidden=false
            webView.scrollView.contentInset = UIEdgeInsets.init(top: 45,left: 0,bottom: 0,right: 0)
        }
        else {
            navBar.isHidden=true
            self.webView.frame = self.view.frame
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        let request = webView.url?.absoluteString
        if (webView.canGoBack && request != "https://www.firstcrush.co/"){
            if(scrollView.contentOffset.y > self.lastOffsetY && scrollView.contentOffset.x == self.lastOffsetX)
            {
                navBar.isHidden = true
        }
        else {
            navBar.isHidden = false
            self.webView.frame = self.view.frame
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
            //print(webView.title!)
            navItem.title = webView.title!
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
                UIApplication.shared.open(navigationAction.request.url!,options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
            else
            {
                print("Inside Segue Web View")
                
                let newVC = UIViewController()
                newVC.view.backgroundColor=UIColor.red
                homeController?.navigationController?.pushViewController(newVC, animated: true)
                homeController?.menuBar.isHidden=true
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
        //print("Back Button Selected")
        if webView.canGoBack {
            webView.goBack()
            navBar.isHidden=true
            webView.scrollView.contentInset = UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
            
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
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
