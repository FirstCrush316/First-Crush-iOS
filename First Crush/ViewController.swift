//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate,WKNavigationDelegate {
    @IBOutlet var wkWebBackgroundView: UIView!
    @IBOutlet var contentView: UIView!
    @objc var webView: WKWebView!
    @objc var myLabel: UILabel!
    @objc var lastOffsetY :CGFloat = 0
    
    @objc var time : Float = 0.0
    @objc var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Removes it:
        //webView.scrollView.delegate = self
        let url = NSURL(string: "http://www.firstcrush.co")
        let request = URLRequest(url: url! as URL)
        if Reachability.isConnectedToNetwork() == true {
            webView.load(request)
        }else {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback=true
        webConfiguration.allowsAirPlayForMediaPlayback=true
        webConfiguration.allowsPictureInPictureMediaPlayback=true
        webView = WKWebView(frame:contentView.frame, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        self.contentView.addSubview(webView!)
        constrainView()
        
        
    }
    
    
    @objc func constrainView() {
        //self.webView = WKWebView(frame: CGRect.zero)
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .width, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .leading, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: wkWebBackgroundView, attribute: .leading, multiplier: 1, constant: 0)
        view.addConstraints([leading,top,trailing,bottom,height,width])
        [webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
         webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
         webView.leftAnchor.constraint(equalTo: view.leftAnchor),
         webView.rightAnchor.constraint(equalTo: view.rightAnchor),
         ].forEach  { anchor in
            anchor.isActive = true
        }
        contentView.backgroundColor=UIColor.black
        webView.backgroundColor=UIColor.black
        webView.autoresizesSubviews=true
        view.backgroundColor=UIColor.black
        self.contentView.clipsToBounds = true
        self.webView.clipsToBounds=true
        webView.uiDelegate = self
        view = webView
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        if webView.canGoBack {
        lastOffsetY = scrollView.contentOffset.y
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        if webView.canGoBack {
        let hide = scrollView.contentOffset.y > self.lastOffsetY
        self.navigationController?.setNavigationBarHidden(hide, animated: true)
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}

