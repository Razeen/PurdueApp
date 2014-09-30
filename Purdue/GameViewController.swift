//
//  GameViewController.swift
//  Purdue
//
//  Created by George Lo on 9/26/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIWebViewDelegate {
    
    var gameWebView: UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("GAMES_TITLE", comment: "")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        self.view.addSubview(gameWebView)
        gameWebView.delegate = self
        let URL = NSURL(string: "http://mobile.rivals.com/schedule.asp?TeamCode=PURDUE&Sport=1")
        gameWebView.loadRequest(NSURLRequest(URL: URL))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
