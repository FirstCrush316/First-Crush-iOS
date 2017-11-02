//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate,WKNavigationDelegate {
    @IBOutlet var contentView: UIView!
    let webConfiguration = WKWebViewConfiguration()
    var webView = WKWebView()
    //@objc var webView: WKWebView!
    @objc var progressView: UIProgressView!
    @objc var myLabel: UILabel!
    @objc var lastOffsetY :CGFloat = 0
    
    @objc var time : Float = 0.0
    @objc var timer: Timer?
    
    var myContext = 0
    
    override func loadView() {
        super.loadView()
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        
        webView = WKWebView(frame:contentView.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleHeight]
        contentView.addSubview(webView)
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
        // Create Progress View
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = #colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        progressView.setProgress(0.0, animated: true)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton]
        navigationController?.isToolbarHidden = false
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        let url = NSURL(string: "http://www.firstcrush.co/your-profile/")
        let request = URLRequest(url: url! as URL)
        if Reachability.isConnectedToNetwork() == true {
            webView.load(request)
            // Allow Scroll to Refresh
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(ViewController.refreshWebView), for: UIControlEvents.valueChanged)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            
        }else {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        lastOffsetY = 0.0
    }
    
    @objc func refreshWebView() {
        // On Scroll to Refresh, Reload Current Page
        webView.reload()
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
        /*let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0)
         let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0)
         let top = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
         let leading = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
         let bottom = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
         let trailing = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
         view.addConstraints([leading,top,trailing,bottom,height,width])*/
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        if webView.canGoBack {
            lastOffsetY = scrollView.contentOffset.y
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.isToolbarHidden = true
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        if webView.canGoBack {
            let hide = scrollView.contentOffset.y > self.lastOffsetY
            self.navigationController?.setNavigationBarHidden(hide, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.isToolbarHidden = true
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
            progressView.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        progressView.isHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        navigationController?.isToolbarHidden = false
        progressView.isHidden = false
    }
}



