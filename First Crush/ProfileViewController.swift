//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import WebKit
import MediaPlayer


class ProfileViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate, WKNavigationDelegate,  UITabBarControllerDelegate {
    @objc var contentView: UIView!
    var webConfiguration = WKWebViewConfiguration()
    @objc var webView = WKWebView()
    //@objc var webView: WKWebView!
    @objc var progressView: UIProgressView!
    @objc var loadSpinner: UIActivityIndicatorView!
    @objc var myLabel: UILabel!
    @objc var lastOffsetY :CGFloat = 0
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @objc var time : Float = 0.0
    @objc var timer: Timer?
    
    var myContext = 0
    
    override func loadView() {
        super.loadView()
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        
        webView = WKWebView(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height), configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleHeight]
        webView.navigationDelegate = self
        contentView.addSubview(webView)
        contentView.sendSubview(toBack: webView)
        webView.translatesAutoresizingMaskIntoConstraints = true
        contentView.backgroundColor=UIColor.black
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scrollView.backgroundColor = UIColor.clear
        //webView.backgroundColor=UIColor.black
        webView.autoresizesSubviews=true
        webView.contentMode = .scaleToFill
        webView.frame = contentView.bounds
        constrainView()
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.center = self.view.center
        view.addSubview(loadSpinner)
        self.tabBarController?.delegate = self
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 68,width: self.view.frame.width,height: self.view.frame.height))
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        progressView.sizeToFit()
        webView.addSubview(progressView)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = true
        let url = NSURL(string: "http://www.firstcrush.co/your-profile/")
        let request = URLRequest(url: url! as URL)
        
        if Reachability.isConnectedToNetwork() == true {
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
            // Allow Scroll to Refresh
            let refreshControl = UIRefreshControl(frame:(CGRect(x: 0,y: 25,width: 25, height: 25)))
            let title = NSLocalizedString("Pull To Refresh", comment: "Pull To Refresh")
            refreshControl.attributedTitle=NSAttributedString(string: title)
            refreshControl.tintColor=UIColor.white
            refreshControl.backgroundColor=UIColor.darkGray
            refreshControl.addTarget(self, action: #selector(ViewController.refreshWebView), for: UIControlEvents.valueChanged)
            webView.scrollView.addSubview(refreshControl)
            webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }else {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        webView.scrollView.delegate = self
        lastOffsetY = 0.0
        
    }
    
    @objc func refreshWebView(sender: UIRefreshControl) {
        // On Scroll to Refresh, Reload Current Page
        print("Reloading Page")
        webView.reload()
        sender.endRefreshing()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Display Progress Bar While Loading Pages
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        //Display Title
        if (keyPath == "title") {
            self.navigationItem.title = webView.title
        }
    }
    @objc func constrainView() {
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack
        {
            lastOffsetY = scrollView.contentOffset.y
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.webView.frame = self.view.bounds
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack {
            let hide = scrollView.contentOffset.y > self.lastOffsetY
            self.navigationController?.setNavigationBarHidden(hide, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.webView.frame = self.view.bounds
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        progressView.isHidden = false
        webView.reload()
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        if Reachability.isConnectedToNetwork() == false {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            self.progressView.setProgress(1.0, animated: true)
            progressView.isHidden = true
            loadSpinner.stopAnimating()
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
        //Handling Lock Screen Events        
        UIApplication.shared.beginReceivingRemoteControlEvents();
        self.becomeFirstResponder();
        print("Started Receiving Remote Control Events")
        
        let mpic = MPNowPlayingInfoCenter.default()
        let image:UIImage = UIImage(named: "AppIcon")!
        let artwork = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
            return image
        })
        mpic.nowPlayingInfo =
            [
                MPMediaItemPropertyArtwork:artwork
        ]
        
        
        let commandCenter=MPRemoteCommandCenter.shared()
        commandCenter.previousTrackCommand.isEnabled = true;
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        
        commandCenter.skipForwardCommand.isEnabled = true;
        MPRemoteCommandCenter.shared().skipForwardCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        commandCenter.skipBackwardCommand.isEnabled = true;
        MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled=true
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        commandCenter.playCommand.isEnabled = true
        MPRemoteCommandCenter.shared().playCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget {
            (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            UIApplication.shared.isStatusBarHidden = true // Landscape
        } else {
            UIApplication.shared.isStatusBarHidden = false //Portrait
        }
    }
    //Disable Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil;
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2 {
            let url = NSURL(string: "http://www.firstcrush.co/your-profile/")
            let request = URLRequest(url: url! as URL)
            webView.load(request)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            lastOffsetY = 0
        }
        
    }
    
}

