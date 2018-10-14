//
//  DetailViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 26/11/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.

import UIKit
import WebKit


class DetailViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate, WKNavigationDelegate,  UITabBarControllerDelegate {
    @IBOutlet var contentView: UIView!
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
    @objc var detailURL: NSURL!
    
    var myContext = 0
    
    func setdetailURL (_ NSURL: NSURL)
    {
    detailURL = NSURL
    }
    
    override func loadView() {
        super.loadView()
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        
        webView = WKWebView(frame:CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height), configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleHeight]
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
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create Load Spinner
        loadSpinner = UIActivityIndicatorView(frame:CGRect(x: self.view.frame.height/2 , y: self.view.frame.width/2 ,width: 37,height: 37))
        loadSpinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        loadSpinner.center = self.view.center
        view.addSubview(loadSpinner)
        // Create Progress View
        progressView = UIProgressView(frame:CGRect(x: 0,y: 68,width: self.view.frame.width,height: self.view.frame.height))
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        progressView.sizeToFit()
        webView.addSubview(progressView)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.alwaysBounceVertical = true
        
        let request = URLRequest(url: detailURL! as URL)
        
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
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }else {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        (self.navigationController?.navigationBar.topItem?.titleView as? UILabel)?.text=webView.title
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
    }
    @objc func constrainView() {
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString
        if webView.canGoBack
        {   lastOffsetY = scrollView.contentOffset.y
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.isToolbarHidden = true
            self.webView.frame = self.view.bounds
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        //let request = webView.url?.absoluteString

        if webView.canGoBack {
                let hide = scrollView.contentOffset.y > self.lastOffsetY
                self.navigationController?.setNavigationBarHidden(hide, animated: true)
                self.webView.frame = self.view.bounds
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.isToolbarHidden = true
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
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                //self.webView.load(navigationAction.request)// It will load that link in same WKWebView
                UIApplication.shared.open(navigationAction.request.url!,options: [:], completionHandler: nil)
            }
        default:
            break
        }
        decisionHandler(.allow)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            //UIApplication.shared.isStatusBarHidden = true // Landscape
        } else {
            //UIApplication.shared.isStatusBarHidden = false //Portrait
        }
    }
    
}


