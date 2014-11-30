//
//  MyMailContentViewController.swift
//  Purdue
//
//  Created by George Lo on 11/27/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import Foundation

class MyMailBodyViewController: UIViewController, UIWebViewDelegate {
    
    var message: MCOIMAPMessage?
    var folder: NSString?
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 84 + 20, 30, 30))
    let scrollView = UIScrollView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 84))
    var headerHeight = CGFloat(0)
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotMessages:", name: "GotMessages", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(progress)
        progress.startAnimating()
        
        AccountUtils.sharedIMAPSession.fetchMessageOperationWithFolder(folder!, uid: message!.uid, urgent: true).start({
            (error: NSError!, data: NSData!) in
            self.progress.stopAnimating()
            self.progress.removeFromSuperview()
            
            self.scrollView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleTopMargin
            self.view.addSubview(self.scrollView)
            
            let fromTitle = UILabel(frame: CGRectZero)
            fromTitle.font = UIFont(name: "HelveticaNeue", size: 15)
            fromTitle.textColor = UIColor(white: 0.4, alpha: 1)
            fromTitle.text = "From:"
            fromTitle.sizeToFit()
            fromTitle.frame = CGRectMake(10, 10, fromTitle.frame.width, fromTitle.frame.height)
            self.scrollView.addSubview(fromTitle)
            
            let fromDetail = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 30 - fromTitle.frame.width, 0))
            fromDetail.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            fromDetail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
            if self.message?.header.sender != nil {
                fromDetail.text = self.message?.header.sender.displayName != nil ? "\(self.message!.header.sender.displayName)<\(self.message!.header.sender.mailbox)>" : self.message!.header.sender.mailbox
                fromDetail.numberOfLines = 0
                fromDetail.sizeToFit()
                fromDetail.frame = CGRectMake(10 + fromTitle.frame.width + 10, 10, UIScreen.mainScreen().bounds.width - 30 - fromTitle.frame.width, fromDetail.frame.height)
                self.scrollView.addSubview(fromDetail)
                
                let fromSeparator = UIView(frame: CGRectMake(0, 20 + fromDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
                fromSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
                self.scrollView.addSubview(fromSeparator)
                
                let onBehalfTitle = UILabel(frame: CGRectZero)
                onBehalfTitle.font = UIFont(name: "HelveticaNeue", size: 15)
                onBehalfTitle.textColor = UIColor(white: 0.4, alpha: 1)
                onBehalfTitle.text = "On behalf of:"
                onBehalfTitle.sizeToFit()
                onBehalfTitle.frame = CGRectMake(10, 30 + fromDetail.frame.height, onBehalfTitle.frame.width, onBehalfTitle.frame.height)
                self.scrollView.addSubview(onBehalfTitle)
                
                let onBehalfDetail = UILabel(frame: CGRectZero)
                onBehalfDetail.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
                onBehalfDetail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
                onBehalfDetail.text = self.message?.header.from.displayName != nil ? "\(self.message!.header.from.displayName)<\(self.message!.header.from.mailbox)>" : self.message!.header.from.mailbox
                onBehalfDetail.numberOfLines = 0;
                onBehalfDetail.sizeToFit()
                onBehalfDetail.frame = CGRectMake(10 + onBehalfTitle.frame.width + 10, 30 + fromDetail.frame.height, UIScreen.mainScreen().bounds.width - 30 - onBehalfTitle.frame.width, onBehalfDetail.frame.height)
                self.scrollView.addSubview(onBehalfDetail)
                
                let onBehalfSeparator = UIView(frame: CGRectMake(0, 10 + onBehalfDetail.frame.origin.y + onBehalfDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
                onBehalfSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
                self.scrollView.addSubview(onBehalfSeparator)
                
                self.headerHeight = 10 + onBehalfDetail.frame.origin.y + onBehalfDetail.frame.height
            } else {
                fromDetail.text = self.message?.header.from.displayName != nil ? "\(self.message!.header.from.displayName)<\(self.message!.header.from.mailbox)>" : self.message!.header.from.mailbox
                fromDetail.numberOfLines = 0
                fromDetail.sizeToFit()
                fromDetail.frame = CGRectMake(10 + fromTitle.frame.width + 10, 10, UIScreen.mainScreen().bounds.width - 30 - fromTitle.frame.width, fromDetail.frame.height)
                self.scrollView.addSubview(fromDetail)
                
                let fromSeparator = UIView(frame: CGRectMake(0, 20 + fromDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
                fromSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
                self.scrollView.addSubview(fromSeparator)
                
                self.headerHeight = 20 + fromDetail.frame.height
            }
            
            let toTitle = UILabel(frame: CGRectZero)
            toTitle.font = UIFont(name: "HelveticaNeue", size: 15)
            toTitle.textColor = UIColor(white: 0.4, alpha: 1)
            toTitle.text = "To:"
            toTitle.sizeToFit()
            toTitle.frame = CGRectMake(10, 10 + self.headerHeight, toTitle.frame.width, toTitle.frame.height)
            self.scrollView.addSubview(toTitle)
            
            let toDetail = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 30 - toTitle.frame.width, 0))
            toDetail.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            toDetail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
            toDetail.text = ""
            for i in 0 ... self.message!.header.to.count - 1 {
                let addr = self.message!.header.to[i] as MCOAddress
                var str = addr.displayName != nil ? "\(addr.displayName)<\(addr.mailbox)>" : addr.mailbox
                if i != self.message!.header.to.count - 1 {
                    str = str + ", "
                }
                toDetail.text = toDetail.text! + str
            }
            toDetail.numberOfLines = 0;
            toDetail.sizeToFit()
            toDetail.frame = CGRectMake(20 + toTitle.frame.width, 10 + self.headerHeight, toDetail.frame.width, toDetail.frame.height)
            self.scrollView.addSubview(toDetail)
            
            let toSeparator = UIView(frame: CGRectMake(0, 10 + toDetail.frame.origin.y + toDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
            toSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
            self.scrollView.addSubview(toSeparator)
            
            self.headerHeight = 10 + toDetail.frame.origin.y + toDetail.frame.height
            
            if self.message!.header.cc != nil {
                let ccTitle = UILabel(frame: CGRectZero)
                ccTitle.font = UIFont(name: "HelveticaNeue", size: 15)
                ccTitle.textColor = UIColor(white: 0.4, alpha: 1)
                ccTitle.text = "Cc:"
                ccTitle.sizeToFit()
                ccTitle.frame = CGRectMake(10, 10 + self.headerHeight, ccTitle.frame.width, ccTitle.frame.height)
                self.scrollView.addSubview(ccTitle)
                
                let ccDetail = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 30 - ccTitle.frame.width, 0))
                ccDetail.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
                ccDetail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
                ccDetail.text = ""
                for i in 0 ... self.message!.header.cc.count - 1 {
                    let addr = self.message!.header.cc[i] as MCOAddress
                    var str = addr.displayName != nil ? "\(addr.displayName)<\(addr.mailbox)>" : addr.mailbox
                    if i != self.message!.header.cc.count - 1 {
                        str = str + ", "
                    }
                    ccDetail.text = ccDetail.text! + str
                }
                ccDetail.numberOfLines = 0;
                ccDetail.sizeToFit()
                ccDetail.frame = CGRectMake(20 + ccTitle.frame.width, 10 + self.headerHeight, ccDetail.frame.width, ccDetail.frame.height)
                self.scrollView.addSubview(ccDetail)
                
                let ccSeparator = UIView(frame: CGRectMake(0, 10 + ccDetail.frame.origin.y + ccDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
                ccSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
                self.scrollView.addSubview(ccSeparator)
                
                self.headerHeight = 10 + ccDetail.frame.origin.y + ccDetail.frame.height
            }
            
            if self.message!.header.bcc != nil {
                let bccTitle = UILabel(frame: CGRectZero)
                bccTitle.font = UIFont(name: "HelveticaNeue", size: 15)
                bccTitle.textColor = UIColor(white: 0.4, alpha: 1)
                bccTitle.text = "Cc:"
                bccTitle.sizeToFit()
                bccTitle.frame = CGRectMake(10, 10 + self.headerHeight, bccTitle.frame.width, bccTitle.frame.height)
                self.scrollView.addSubview(bccTitle)
                
                let bccDetail = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 30 - bccTitle.frame.width, 0))
                bccDetail.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
                bccDetail.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
                bccDetail.text = ""
                for i in 0 ... self.message!.header.bcc.count - 1 {
                    let addr = self.message!.header.bcc[i] as MCOAddress
                    var str = addr.displayName != nil ? "\(addr.displayName)<\(addr.mailbox)>" : addr.mailbox
                    if i != self.message!.header.bcc.count - 1 {
                        str = str + ", "
                    }
                    bccDetail.text = bccDetail.text! + str
                }
                bccDetail.numberOfLines = 0;
                bccDetail.sizeToFit()
                bccDetail.frame = CGRectMake(20 + bccTitle.frame.width, 10 + self.headerHeight, bccDetail.frame.width, bccDetail.frame.height)
                self.scrollView.addSubview(bccDetail)
                
                let bccSeparator = UIView(frame: CGRectMake(0, 10 + bccDetail.frame.origin.y + bccDetail.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
                bccSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
                self.scrollView.addSubview(bccSeparator)
                
                self.headerHeight = 10 + bccDetail.frame.origin.y + bccDetail.frame.height
            }
            
            let timeLabel = UILabel(frame: CGRectMake(10, 10 + self.headerHeight, UIScreen.mainScreen().bounds.width - 20, 18))
            timeLabel.font = UIFont(name: "HelveticaNeue", size: 15)
            timeLabel.textColor = UIColor(white: 0.3, alpha: 1)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM dd, yyyy, hh:mm a"
            timeLabel.text = dateFormatter.stringFromDate(self.message!.header.date)
            self.scrollView.addSubview(timeLabel)
            
            let timeSeparator = UIView(frame: CGRectMake(0, 10 + timeLabel.frame.origin.y + timeLabel.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
            timeSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
            self.scrollView.addSubview(timeSeparator)
            
            self.headerHeight = 10 + timeLabel.frame.origin.y + timeLabel.frame.height
            
            let subjectLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 20, 0))
            subjectLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            subjectLabel.textColor = UIColor(white: 0.1, alpha: 1)
            subjectLabel.text = self.message!.header.subject
            subjectLabel.numberOfLines = 0
            subjectLabel.sizeToFit()
            subjectLabel.frame = CGRectMake(10, 10 + self.headerHeight, UIScreen.mainScreen().bounds.width - 20, subjectLabel.frame.height)
            self.scrollView.addSubview(subjectLabel)
            
            let subjectSeparator = UIView(frame: CGRectMake(0, 10 + subjectLabel.frame.origin.y + subjectLabel.frame.height - 0.25, UIScreen.mainScreen().bounds.width, 0.5))
            subjectSeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
            self.scrollView.addSubview(subjectSeparator)
            
            self.headerHeight = 10 + subjectLabel.frame.origin.y + subjectLabel.frame.height
            
            let messageParser = MCOMessageParser(data: data!)
            var msgHTMLBody = messageParser.htmlBodyRendering() as NSString
            msgHTMLBody = msgHTMLBody.substringWithRange(NSMakeRange(46, msgHTMLBody.length - 46 - 7))
            
            let fontSizeDict = NSMutableDictionary()
            let regex = NSRegularExpression(pattern: "font-size:[ ]?(.*?)px", options: nil, error: nil)
            let matchAry = regex!.matchesInString(msgHTMLBody, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, msgHTMLBody.length))
            for match: NSTextCheckingResult in matchAry as [NSTextCheckingResult] {
                let fontsize = msgHTMLBody.substringWithRange(match.rangeAtIndex(1)) as NSString
                if fontSizeDict[fontsize] == nil {
                    let newfontsize = "\(Int(fontsize.floatValue * 1.3))" as NSString
                    fontSizeDict.setObject(newfontsize, forKey: fontsize)
                }
            }
            
            let allKeys = fontSizeDict.allKeys as NSArray
            if allKeys.count > 0 {
                for i in 0...allKeys.count - 1 {
                    let key = allKeys[i] as NSString
                    msgHTMLBody = msgHTMLBody.stringByReplacingOccurrencesOfString(key, withString: fontSizeDict[key] as NSString)
                }
            }
            
            if self.message?.attachments().count > 0 {
                let hrLoc = msgHTMLBody.rangeOfString("<hr/>", options: NSStringCompareOptions.BackwardsSearch).location
                msgHTMLBody = "\(msgHTMLBody.substringWithRange(NSMakeRange(0, hrLoc)))\(msgHTMLBody.substringWithRange(NSMakeRange(hrLoc + 5, msgHTMLBody.length - hrLoc - 5)))"
                
                fontSizeDict.removeAllObjects()
                let fontSizeDict = NSMutableDictionary()
                let regex = NSRegularExpression(pattern: "<div>- .*?..*?, [1-9]+(.[1-9]+)? [A-Za-z]+</div>", options: nil, error: nil)
                let matchAry = regex!.matchesInString(msgHTMLBody, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, msgHTMLBody.length))
                for match: NSTextCheckingResult in matchAry as [NSTextCheckingResult] {
                    fontSizeDict.setObject("", forKey: msgHTMLBody.substringWithRange(match.rangeAtIndex(0)) as NSString)
                }
                
                let allKeys = fontSizeDict.allKeys as NSArray
                for i in 0...allKeys.count - 1 {
                    let key = allKeys[i] as NSString
                    msgHTMLBody = msgHTMLBody.stringByReplacingOccurrencesOfString(key, withString: fontSizeDict[key] as NSString)
                }
            }
            
            let webView = UIWebView(frame: CGRectMake(0, self.headerHeight + 1, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
            webView.delegate = self
            self.scrollView.addSubview(webView)
            webView.loadHTMLString(msgHTMLBody, baseURL: nil)
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let contentSize = webView.scrollView.contentSize
        let viewSize = self.view.bounds.size
        let rw = viewSize.width / contentSize.width
        
        webView.scrollView.minimumZoomScale = rw
        webView.scrollView.maximumZoomScale = rw
        webView.scrollView.zoomScale = rw
        webView.scrollView.scrollEnabled = false
        webView.frame = CGRectMake(0, self.headerHeight + 1, UIScreen.mainScreen().bounds.width, webView.scrollView.contentSize.height)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.headerHeight + 1 + webView.scrollView.contentSize.height)
    }
    
    /*func fetchIMAPPartWithUniqueID(partUniqueID: NSString, folder: NSString) -> MCOIMAPFetchContentOperation? {
        if (pending?.containsObject(partUniqueID) == true) {
            return nil
        }
        
        let part = message?.partForUniqueID(partUniqueID) as? MCOIMAPPart
        assert(part != nil, "part != nil")
        
        pending?.addObject(partUniqueID)
        
        let op = AccountUtils.sharedIMAPSession.fetchMessageAttachmentOperationWithFolder(folder, uid: message!.uid, partID: part?.partID, encoding: part!.encoding)
        ops?.addObject(op)
        op.start({
            (error: NSError!, data: NSData!) in
            if error.code != MCOErrorCode.None.rawValue {
                return
            }
            
            assert(data != nil, "data != nil")
            self.ops?.removeObject(op)
            self.storage![partUniqueID] = data
            self.pending?.removeObject(partUniqueID)
        })
        
        return op
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
