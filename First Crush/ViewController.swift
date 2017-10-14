//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate {
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var myLabel: UILabel!
    var lastOffsetY :CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Removes it:
        self.webView.delegate = self
        webView.scrollView.delegate = self
        view.addSubview(webView)
        let url = URL(string: "http://www.firstcrush.co")
        let request = URLRequest(url: url!)
            webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ : UIWebView) {
        loadSpinner.startAnimating()
        myLabel.isHidden=false;
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        loadSpinner.stopAnimating()
        myLabel.isHidden=false;
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        lastOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        
        let hide = scrollView.contentOffset.y > self.lastOffsetY
        self.navigationController?.setNavigationBarHidden(hide, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        webView.reload()
    }
}

