//
//  WebBrowserViewController.swift
//  Purdue
//
//  Created by George Lo on 1/15/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class WebBrowserViewController: UIViewController, UIWebViewDelegate {
    
    var urlString: NSString = ""
    let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    var currentTimer = NSTimer()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = UIWebView(frame: CGRectZero)
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        self.view = webView
        
        progressView.trackTintColor = UIColor(white: 1, alpha: 0)
        progressView.frame = CGRectMake(0, self.navigationController!.navigationBar.frame.size.height - self.progressView.frame.size.height, UIScreen.mainScreen().bounds.width, self.progressView.frame.size.height)
        progressView.tintColor = ColorUtils.Legacy.OldGold
        progressView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        self.navigationController?.navigationBar.addSubview(progressView)
        
        self.navigationController?.navigationBar.tintColor = ColorUtils.Legacy.OldGold
        self.navigationController?.toolbar.tintColor = ColorUtils.Legacy.OldGold
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        currentTimer.invalidate()
        currentTimer = NSTimer.scheduledTimerWithTimeInterval(0.5/240.0, target: self, selector: "fakeComplete", userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        currentTimer.invalidate()
        currentTimer = NSTimer.scheduledTimerWithTimeInterval(0.5/240.0, target: self, selector: "fakeComplete", userInfo: nil, repeats: true)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        progressView.alpha = 1.0
        currentTimer.invalidate()
        currentTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: "fakeStart", userInfo: nil, repeats: true)
    }
    
    func fakeStart() {
        let progress: CGFloat = 0.3
        if CGFloat(progressView.progress) != progress {
            progressView.setProgress(progressView.progress + 0.005, animated: true)
        } else {
            currentTimer.invalidate()
        }
    }
    
    func fakeComplete() {
        let progress: CGFloat = 1.0
        if CGFloat(progressView.progress) != progress {
            progressView.setProgress(progressView.progress + 0.005, animated: true)
        } else {
            currentTimer.invalidate()
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.progressView.alpha = 0.0
                }, completion: { finished in
                self.progressView.setProgress(0.0, animated: false)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
