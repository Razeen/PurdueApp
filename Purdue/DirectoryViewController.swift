//
//  DirectoryViewController.swift
//  Purdue
//
//  Created by George Lo on 10/3/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class DirectoryViewController: UITableViewController, UISearchBarDelegate {
    
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 64, 30, 30))
    var students: [DirectoryStudent] = []
    
    let kNameTag = 101
    let kSchoolLabelTag = 104
    let kEmailLabelTag = 105
    
    var imageView = UIImageView(image: UIImage(named: "Oops"))
    var statusLabel: UILabel?
    
    convenience override init() {
        self.init(style: .Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.tintColor = ColorUtils.Core.Brown
        
        imageView.frame = CGRectMake((UIScreen.mainScreen().bounds.width - imageView.frame.width / 1.5) / 2, 44 + 40, imageView.frame.width / 1.5, imageView.frame.height / 1.5)
        statusLabel = UILabel(frame: CGRectMake(20, imageView.frame.height + imageView.frame.origin.y + 40, UIScreen.mainScreen().bounds.width - 40, 50))
        statusLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        statusLabel!.numberOfLines = 2
        statusLabel!.textAlignment = NSTextAlignment.Center

        self.navigationItem.title = I18N.localizedString("DIRECTORY_TITLE")
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        searchBar.delegate = self
        searchBar.placeholder = I18N.localizedString("DIRECTORY_SEARCH_PROMPT")
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.progress.startAnimating()
        self.view.addSubview(progress)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.students.removeAll(keepCapacity: true)
            let request = NSMutableURLRequest(URL: NSURL(string: "http://www.itap.purdue.edu/directory/")!)
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            let requestString = searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) as NSString!
            let postData = ("search=\(requestString)" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = postData
            request.setValue("\(postData?.length)", forHTTPHeaderField: "Content-Length")
            let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            var statusString: NSString?
            if data != nil {
                var response = NSString(data: data!, encoding: NSUTF8StringEncoding)
                response = response?.stringByReplacingOccurrencesOfString("\t", withString: "")
                response = response?.stringByReplacingOccurrencesOfString("\n", withString: "")
                response = response?.stringByReplacingOccurrencesOfString("\r", withString: "")
                
                let regex = NSRegularExpression(pattern: "i id=\".*?\".*?alias=(.*?)&.*?fn\">(.*?)</span><ul><li>School:<span class=\"school\">(.*?)<.*?(mailto:(.*?)\">.*?)?</u", options: nil, error: nil)
                let matchAry = regex!.matchesInString(response!, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, response!.length))
                for match: NSTextCheckingResult in matchAry as [NSTextCheckingResult] {
                    let student = DirectoryStudent()
                    student.alias = response?.substringWithRange(match.rangeAtIndex(1))
                    student.name = response?.substringWithRange(match.rangeAtIndex(2))
                    student.school = response?.substringWithRange(match.rangeAtIndex(3))
                    if match.rangeAtIndex(4).location != NSNotFound {
                        student.email = response?.substringWithRange(match.rangeAtIndex(5))
                    }
                    self.students.append(student)
                }
                
                if self.students.count == 0 {
                    if response?.containsString("Your search returned no results.") == true {
                        statusString = I18N.localizedString("DIRECTORY_ERR_NONE")
                    } else {
                        statusString = I18N.localizedString("DIRECTORY_ERR_MANY")
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimating()
                self.progress.removeFromSuperview()
                self.imageView.removeFromSuperview()
                self.statusLabel!.removeFromSuperview()
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                if self.students.count == 0 {
                    self.statusLabel!.text = statusString!
                    self.view.addSubview(self.imageView)
                    self.view.addSubview(self.statusLabel!)
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return students.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        let student = students[indexPath.row]

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let nameLabel = UILabel(frame: CGRectMake(15, 5, UIScreen.mainScreen().bounds.width - 15 - 44, 25))
            nameLabel.tag = kNameTag
            nameLabel.font = UIFont (name: "Avenir-Heavy", size: 20)
            cell?.contentView.addSubview(nameLabel)
            
            let schoolImage = UIImageView(image: UIImage(named: "DirectorySchool")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
            schoolImage.frame = CGRectMake(30, 33.5, 15, 15)
            schoolImage.contentMode = UIViewContentMode.ScaleAspectFill
            schoolImage.tintColor = UIColor(red: 163.0/255, green: 121.0/255, blue: 44.0/255, alpha: 1)
            cell?.contentView.addSubview(schoolImage)
            
            let schoolLabel = UILabel(frame: CGRectMake(54, 31, UIScreen.mainScreen().bounds.width - 54 - 44, 20))
            schoolLabel.tag = kSchoolLabelTag
            schoolLabel.font = UIFont (name: "Avenir", size: 16)
            cell?.contentView.addSubview(schoolLabel)
            
            let emailImage = UIImageView(image: UIImage(named: "DirectoryEmail")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
            emailImage.frame = CGRectMake(28, 56, 19, 12.5)
            emailImage.contentMode = UIViewContentMode.ScaleToFill
            emailImage.tintColor = UIColor(red: 114.0/255, green: 153.0/255, blue: 198.0/255, alpha: 1)
            cell?.contentView.addSubview(emailImage)
            
            let emailLabel = UILabel(frame: CGRectMake(54, 52, UIScreen.mainScreen().bounds.width - 54 - 44, 20))
            emailLabel.tag = kEmailLabelTag
            emailLabel.font = UIFont (name: "Avenir", size: 16)
            cell?.contentView.addSubview(emailLabel)
        }
        
        if let label = (cell?.contentView.viewWithTag(kNameTag) as? UILabel) {
            label.text = student.name
        }
        if let label = (cell?.contentView.viewWithTag(kSchoolLabelTag) as? UILabel) {
            label.text = student.school
        }
        if student.email != nil {
            if let label = (cell?.contentView.viewWithTag(kEmailLabelTag) as? UILabel) {
                label.font = UIFont (name: "Avenir", size: 16)
                label.text = student.email
            }
        } else {
            if let label = (cell?.contentView.viewWithTag(kEmailLabelTag) as? UILabel) {
                label.font = UIFont(name: "Avenir-Oblique", size: 14)
                label.text = "N/A"
            }
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DirectoryDetailViewController()
        detailVC.alias = students[indexPath.row].alias
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
