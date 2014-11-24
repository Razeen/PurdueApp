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
    var username: String?
    var password: String?
    var originalY: CGFloat = -1

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
        titleLabel.text = "Purdue Account"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 27)
        blackOverlay.addSubview(titleLabel)
        
        let tfwidth = baseView.frame.width - 30
        let tfheight = CGFloat(44)
        let userTF = self.makeTF(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.575, tfwidth, 44), tag: 0, delegate: self, placeholder: "Username", imageName: "Username")
        let passTF = self.makeTF(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.7, tfwidth, 44), tag: 1, delegate: self, placeholder: "Password", imageName: "Password")
        passTF.secureTextEntry = true
        blackOverlay.addSubview(userTF)
        blackOverlay.addSubview(passTF)
        
        signInBtn = self.makeBT(CGRectMake((baseView.frame.width - tfwidth) / 2, baseView.frame.height * 0.85, tfwidth, 44), title: "SIGN IN")
        signInBtn!.addTarget(self, action: "signIn", forControlEvents: UIControlEvents.TouchUpInside)
        blackOverlay.addSubview(self.signInBtn!)
        /**/
        
        /*
        
        
        let session = MCOIMAPSession()
        session.hostname = "mymail.purdue.edu"
        session.port = 993
        session.connectionType = MCOConnectionType.TLS
        session.fetchAllFoldersOperation().start( { (err: NSError!, folders: [AnyObject]!) in
            if err != nil {
                println("Error: \(err)")
            } else {
                println("Folders: \(folders)")
            }
        })*/
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 0 {
            username = textField.text
        } else {
            password = textField.text
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
