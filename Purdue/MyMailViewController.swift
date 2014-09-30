//
//  MyMailViewController.swift
//  Purdue
//
//  Created by George Lo on 9/30/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class MyMailViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView: UIWebView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL.URLWithString("https://mymail.purdue.edu/")))
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        NSLog(error.description)
        SCLAlertView().showError(self.navigationController!, title: "Failed to load", subTitle: "Please try again later") // Error
    }

}
