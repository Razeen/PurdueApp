//
//  SignInViewController.swift
//  Purdue
//
//  Created by George Lo on 11/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var signInBtn: UIButton?
    var originalY: CGFloat = -1
    
    var userTF: UITextField?
    var passTF: UITextField?
    
    var source: UIViewController?
    
    required init(source: UIViewController) {
        super.init()
        self.source = source
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseView = UIImageView(image: UIImage(named: "SignInWallpaper")?.blurredImageWithRadius(15, iterations: 6, tintColor: UIColor.blackColor()))
        baseView.userInteractionEnabled = true
        baseView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.85, UIScreen.mainScreen().bounds.height * 0.85)
        self.view = baseView
        
        let blackOverlay = UIView(frame: baseView.frame)
        blackOverlay.backgroundColor = UIColor(white: 0.13, alpha: 0.68)
        blackOverlay.userInteractionEnabled = true
        baseView.addSubview(blackOverlay)
        
        let sideLength = min(baseView.frame.height * 0.425, baseView.frame.width / 2)
        let iconIV = UIImageView(image: UIImage(named: "Icon"))
        iconIV.frame = CGRectMake((baseView.frame.width - sideLength)/2, (baseView.frame.height * 0.425 - sideLength) / 2 + 10, sideLength, sideLength)
        iconIV.layer.shadowColor = UIColor.whiteColor().CGColor
        iconIV.layer.shadowRadius = 10
        iconIV.layer.shadowOpacity = 0.7
        iconIV.layer.shadowOffset = CGSizeMake(0, 0)
        blackOverlay.addSubview(iconIV)
        
        let titleLabel = UILabel(frame: CGRectMake(0, baseView.frame.height * 0.425 + 10, baseView.frame.width, baseView.frame.height * 0.1 - 10))
        titleLabel.text = I18N.localizedString("SIGNIN_PURDUE_ACCOUNT")
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 27)
        blackOverlay.addSubview(titleLabel)
        
        let tfwidth = baseView.frame.width - 30
        let tfheight = CGFloat(44)
        userTF = self.makeTF(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.575, tfwidth, 44), tag: 0, delegate: self, placeholder: I18N.localizedString("USERNAME"), imageName: "Username")
        passTF = self.makeTF(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.7, tfwidth, 44), tag: 1, delegate: self, placeholder: I18N.localizedString("PASSWORD"), imageName: "Password")
        passTF!.secureTextEntry = true
        blackOverlay.addSubview(userTF!)
        blackOverlay.addSubview(passTF!)
        
        signInBtn = self.makeBT(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.85, tfwidth, 44), title: I18N.localizedString("SIGNIN_SIGN_IN"))
        signInBtn!.addTarget(self, action: "signIn", forControlEvents: UIControlEvents.TouchUpInside)
        blackOverlay.addSubview(self.signInBtn!)
    }
    
    func signIn() {
        userTF?.resignFirstResponder()
        passTF?.resignFirstResponder()
        
        if self.originalY != -1 {
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame = CGRectMake(self.view.frame.origin.x, self.originalY, self.view.frame.size.width, self.view.frame.size.height)
            })
        }
        
        if userTF?.text.utf16Count <= 0 {
            SCLAlertView().showWarning((UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController!, title: I18N.localizedString("ERROR"), subTitle: I18N.localizedString("SIGNIN_ERR_USERNAME_BLANK"))
        } else if passTF?.text.utf16Count <= 0 {
            SCLAlertView().showWarning((UIApplication.sharedApplication().delegate as AppDelegate).slidingViewController!, title: I18N.localizedString("ERROR"), subTitle: I18N.localizedString("SIGNIN_ERR_PASSWORD_BLANK"))
        } else {
            /**
                Purdue Account - Authentication
                
                :info: Using Blackboard API since it's faster than IMAP
            */
            
            // prepare the POST params
            let postString = NSString(format: "username=%@&password=%@", userTF!.text, passTF!.text)
            
            // set the POST request
            let request = NSMutableURLRequest(URL: NSURL(string: "https://mycourses.purdue.edu/webapps/Bb-mobile-BBLEARN/sslUserLogin?v=2&f=xml&ver=4.1.2&registration_id=11946")!)
            request.HTTPMethod = "POST"
            request.setValue("\(postString.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            
            // send the request
            let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            let resp = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            // parse the response
            if resp?.containsString("OK") == true {
                self.source!.dismissPopupViewControllerAnimated(true, completion: {
                    AccountUtils.setUsername(self.userTF!.text)
                    AccountUtils.setPassword(self.passTF!.text)
                    NSNotificationCenter.defaultCenter().postNotificationName("signInSuccess", object: self)
                })
            } else {
                SCLAlertView().showError(self.source!, title: I18N.localizedString("ERROR"), subTitle: I18N.localizedString("SIGNIN_ERR_NOT_FOUND"))
            }
        }
    }
    
    func makeBT(rect: CGRect, title: NSString) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.frame = rect
        button.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitle(title, forState: UIControlState.Normal)
        return button
    }
    
    func makeTF(rect: CGRect, tag: NSInteger, delegate: UITextFieldDelegate, placeholder: NSString, imageName: NSString) -> UITextField {
        let textField = UITextField(frame: rect)
        textField.tag = tag
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        textField.delegate = delegate
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.returnKeyType = UIReturnKeyType.Done
        textField.userInteractionEnabled = true
        textField.backgroundColor = UIColor(white: 0.1, alpha: 0.75)
        textField.textColor = UIColor.whiteColor()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.6, alpha: 1.0)])
        let iconBox = UIView(frame: CGRectMake(0, 0, rect.size.height + 20, rect.size.height))
        let iconIV = UIImageView(image: UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        iconIV.tintColor = UIColor.whiteColor()
        iconIV.frame = CGRectMake(10, 9, 26, 26)
        iconIV.contentMode = UIViewContentMode.ScaleAspectFit
        iconBox.addSubview(iconIV)
        let separatorLine = UIView(frame: CGRectMake(46, 8, 1, 28))
        separatorLine.backgroundColor = UIColor.whiteColor()
        iconBox.addSubview(separatorLine)
        textField.leftView = iconBox
        textField.leftViewMode = UITextFieldViewMode.Always
        return textField
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if originalY == -1 {
            originalY = self.view.frame.origin.y
        }
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectMake(self.view.frame.origin.x, -210, self.view.frame.size.width, self.view.frame.size.height)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.originalY, self.view.frame.size.width, self.view.frame.size.height)
        })
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
