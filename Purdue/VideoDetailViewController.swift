//
//  VideoDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 11/2/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController, UIWebViewDelegate {
    
    var selectedVideo: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedVideo?.title
        
        let youtubeWV = UIWebView(frame: self.view.bounds)
        youtubeWV.delegate = self
        youtubeWV.loadRequest(NSURLRequest(URL: selectedVideo!.url!))
        self.view.addSubview(youtubeWV)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        SCLAlertView().showError(self, title: "Error Loading", subTitle: "Please try reloading later")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}
