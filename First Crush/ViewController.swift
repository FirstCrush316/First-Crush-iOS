//
//  ViewController.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var myLabel: UILabel!
    var lastOffsetY :CGFloat = 0
    
    var time : Float = 0.0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Removes it:
        self.webView.delegate = self
        webView.scrollView.delegate = self
        view.addSubview(webView)
        let url = URL(string: "http://www.firstcrush.co")
        let request = URLRequest(url: url!)
        if Reachability.isConnectedToNetwork() == true {
            webView.loadRequest(request)
             timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ViewController.setProgress), userInfo: nil, repeats: true)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
                //Do whatever you wants here
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
}
    func setProgress() {
        time += 0.1
        progressView.progress = time / 5
        if time >= 5 {
            timer!.invalidate()
        }
    }
    func webViewDidStartLoad(_ : UIWebView) {
       self.progressView.setProgress(0.1, animated: true)
        myLabel.isHidden=false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
        self.progressView.setProgress(1.0, animated: true)
            })

    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
       self.progressView.setProgress(1.0, animated: true)
        myLabel.isHidden=true
        self.progressView.isHidden=true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.setProgress(1.0, animated: true)
        if Reachability.isConnectedToNetwork() == false {
        let alertController = UIAlertController(title: NSLocalizedString("No Internet Connection",comment:""), message: NSLocalizedString("Please ensure your device is connected to the internet.",comment:""), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (pAlert) in
            //Do whatever you wants here
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }
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
}

