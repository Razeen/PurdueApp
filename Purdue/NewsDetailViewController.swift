//
//  NewsDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 10/29/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, UIWebViewDelegate {
    
    var url: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Purdue News"
        let webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        self.view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: url!))
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        SCLAlertView().showError(self, title: "Error Loading", subTitle: "Please try reloading later")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //self.navigationItem.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
