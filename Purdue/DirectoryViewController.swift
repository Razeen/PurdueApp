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
    
    convenience override init() {
        self.init(style: .Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Directory"
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
        searchBar.delegate = self
        searchBar.placeholder = "People Search"
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
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimating()
                self.progress.removeFromSuperview()
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return students.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if students[indexPath.row].email != nil {
            return 75
        }
        return 55
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        let kNameTag = 101
        let kSchoolLabelTag = 104
        let kEmailLabelTag = 105
        
        let student = students[indexPath.row]

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            
            let nameLabel = UILabel(frame: CGRectMake(15, 5, UIScreen.mainScreen().bounds.width - 15 - 44, 25))
            nameLabel.tag = kNameTag
            nameLabel.font = UIFont (name: "Avenir-Heavy", size: 20)
            cell?.contentView.addSubview(nameLabel)
            
            let schoolImage = UIImageView(image: UIImage(named: "DirectorySchool")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
            schoolImage.frame = CGRectMake(30, 32.5, 15, 15)
            schoolImage.contentMode = UIViewContentMode.ScaleAspectFill
            schoolImage.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
            cell?.contentView.addSubview(schoolImage)
            
            let schoolLabel = UILabel(frame: CGRectMake(54, 30, UIScreen.mainScreen().bounds.width - 54 - 44, 20))
            schoolLabel.tag = kSchoolLabelTag
            schoolLabel.font = UIFont (name: "Avenir", size: 16)
            cell?.contentView.addSubview(schoolLabel)
            
            if student.email != nil {
                let emailImage = UIImageView(image: UIImage(named: "DirectoryEmail")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
                emailImage.frame = CGRectMake(30, 53.5, 15, 13)
                emailImage.contentMode = UIViewContentMode.ScaleAspectFill
                emailImage.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
                cell?.contentView.addSubview(emailImage)
                
                let emailLabel = UILabel(frame: CGRectMake(54, 50, UIScreen.mainScreen().bounds.width - 54 - 44, 20))
                emailLabel.tag = kEmailLabelTag
                emailLabel.font = UIFont (name: "Avenir", size: 16)
                cell?.contentView.addSubview(emailLabel)
            }
        }
        
        (cell?.contentView.viewWithTag(kNameTag) as UILabel).text = student.name
        (cell?.contentView.viewWithTag(kSchoolLabelTag) as UILabel).text = student.school
        if student.email != nil {
            (cell?.contentView.viewWithTag(kEmailLabelTag) as UILabel).text = student.email
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DirectoryDetailViewController()
        detailVC.alias = students[indexPath.row].alias
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .Done, target: self.navigationController, action: "popViewControllerAnimated:")
        detailVC.navigationItem.leftBarButtonItem?.tintColor = UIColor(white: 0.3, alpha: 1.0)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
