Purdue-App
==========

### General Information
- App Bundle
  - com.PurdueUniversity.Purdue
- App Version
  - 2.0.0
- Compatibility
  - iOS: 7.0, 7.1, 8.0, 8.1
  - Device: iPhone 4/4S/5/5S/6/6+, iPad 2/3/4/Air/Air 2
- Components
  - Main App – Purdue app for iPhone 
  - Extension – iOS 8.1 Notification Center widget
  - Extension – Apple Watch (WatchKit) app
- Design
  - User-Centered Design (UCD)
  - Follows iOS User Interface Guidelines (UIG)
  - Mainly flat design with minor material design
  - Beautiful Typography, using San-serif typeface for headings and clean serif font for detail text
- Libraries
  - AsyncImageView
  - BButton
  - CWPopup
  - ECSlidingViewController
  - FXBlurView
  - KeychainWrapper
  - KINWebBrowser
  - MailCore 2
  - MRProgress
  - MWPhotoBrowser
  - SCLAlertView
  - XMLReader
- Programming Language
  - Swift

### Notes
- Programming Language choice
  - Swift was chosen over Objective-C because we found that our Swift version performs more than 2x as fast as Objective-C version Purdue App.
- Security
  - Sensitive Information, including username and password, are saved to iOS (not the app) using Apple’s Keychain services. In addition, in case that Keychain gets exploited, we decided to use AES-256 encryption to add another layer of security. For more about AES-256, see http://en.wikipedia.org/wiki/Advanced_Encryption_Standard
  - Communications are done through HTTPS whenever it’s possible to avoid HTTP. In reality, SSL can be decrypted, but much more difficult than HTTP.
  - Images are put into Image.xcassets, so that the images would not be able to seen or retrieved by hackers since they will be ‘compiled’.
- User Credential
  - Username and Password are saved as described in the security bullet above
  - User will be logged in until he/she presses the sign out button in Settings screen. By the time the button is pressed, Username and Password will be wiped from iOS
  - The only required sections are Blackboard and MyMail. User credential for Schedule section is optional.
- Screenshots and Videos
  - https://www.dropbox.com/sh/5371ojqbqqrfb2j/AACc_zT_OHf9r28TiAWKRkHNa?dl=0
