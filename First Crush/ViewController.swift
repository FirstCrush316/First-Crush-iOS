//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation;
import MediaPlayer;

class ViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate, WKNavigationDelegate,  UITabBarControllerDelegate {
    var webConfiguration = WKWebViewConfiguration()
     @objc var contentView: UIView!
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
    var mPlayer:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Web View
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        webView = WKWebView(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height), configuration: webConfiguration)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsLinkPreview=false
        webView.allowsBackForwardNavigationGestures=false
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = true
        view.backgroundColor=UIColor.black
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scrollView.backgroundColor = UIColor.clear
        view.addSubview(webView)
        webView.navigationDelegate = self
        //webView.backgroundColor=UIColor.black
        webView.autoresizesSubviews=true
        webView.contentMode = .scaleToFill
        webView.frame = view.bounds
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        webView.uiDelegate = self
        
        //Create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.center = self.view.center
        webView.addSubview(loadSpinner)
        
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 60,width: self.view.frame.width,height: self.view.frame.height))
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        //progressView.sizeToFit()
        webView.addSubview(progressView)
        
        //Setup Menu Bar
        let menuBar  = MenuBar(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: 60))
        webView.addSubview(menuBar)
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(60)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        
               
        //Load URL if connected to Network
        let url = NSURL(string: "http://www.firstcrush.co")
        let request = URLRequest(url: url! as URL)
        if Reachability.isConnectedToNetwork() == true {
            webView.load(request)
            
        // Implement Scroll to Refresh
            let refreshControl = UIRefreshControl(frame:(CGRect(x: 0,y: 10,width: self.view.frame.width, height: 15)))
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
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        webView.scrollView.delegate = self
        self.tabBarController?.delegate = self
        lastOffsetY = 0.0
        view=webView
    }
    
    @objc func refreshWebView(sender: UIRefreshControl) {
        // On Scroll to Refresh, Reload Current Page
        print("Scroll to Refresh Initiated")
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
    
    //Disable Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil;
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
        /*UIApplication.shared.endReceivingRemoteControlEvents();
        //UIApplication.shared.beginBackgroundTask(expirationHandler:NULL);
        self.resignFirstResponder();
        print("View Will Dissapear")*/
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.setProgress(0.1, animated: false)
        progressView.isHidden = false
        loadSpinner.startAnimating()
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
   
        override func remoteControlReceived(with event: UIEvent?)
    {       print("Remote Event Received")
            switch (event?.subtype) {
            case UIEventSubtype.remoteControlTogglePlayPause?:
                print("Received Headphone Play Pause")
                MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                    return .success
                }
                break;
            case UIEventSubtype.remoteControlPlay?:
                self.mPlayer?.play()
                print("Received Remote Play")
                MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                    return .success
                }
                break;
            case UIEventSubtype.remoteControlPause?:
                self.mPlayer?.pause()
                print("Received Remote Pause")
                MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                    return .success
                }
            break;
            case UIEventSubtype.remoteControlNextTrack?:
               //Handle It
                print("Received Next Event")
                MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                    return .success
                }
            break;
            case UIEventSubtype.remoteControlPreviousTrack?:
              //Handle It
                 print("Received Previous Event")
                MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                    return .success
                }
            break;
            default:
            break;
            }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            let url = NSURL(string: "http://www.firstcrush.co")
            let request = URLRequest(url: url! as URL)
            webView.load(request)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            lastOffsetY = 0
        }

}

}

