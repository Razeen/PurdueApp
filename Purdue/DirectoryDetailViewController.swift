//
//  DirectoryDetailViewController.swift
//  Purdue
//
//  Created by George Lo on 11/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit

class DirectoryDetailViewController: UITableViewController {
    
    let progress = MRActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 30 ) / 2, 64, 30, 30))
    var alias: NSString?
    
    var careerLogin: NSString?
    var email: NSString?
    var school: NSString?
    var campus: NSString?
    var qualifiedName: NSString?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Information"

        self.progress.startAnimating()
        self.view.addSubview(progress)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let data = NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL(string: "https://www.itap.purdue.edu/directory/detail.cfm?alias=\(self.alias!)")!), returningResponse: nil, error: nil)
            if data != nil {
                var response = NSString(data: data!, encoding: NSUTF8StringEncoding)
                response = response?.stringByReplacingOccurrencesOfString("\t", withString: "")
                response = response?.stringByReplacingOccurrencesOfString("\n", withString: "")
                response = response?.stringByReplacingOccurrencesOfString("\r", withString: "")
                
                let regex = NSRegularExpression(pattern: "<tr class=\"odd\"><th scope=\"row\">Career Acct. Login:</th><td>(.*?)</td></tr>(<tr.*?><th scope=\"row\">E-mail:</th><td><a href=\"mailto:.*?\">(.*?)</a></td></tr>)?<tr.*?><th scope=\"row\">School:</th><td>(.*?)</td></tr><tr.*?><th scope=\"row\">Campus:</th><td>(.*?)</td></tr><tr.*?>Qualified Name:</th><td>(.*?)</td></tr>", options: nil, error: nil)
                let matchAry = regex!.matchesInString(response!, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, response!.length))
                for match: NSTextCheckingResult in matchAry as [NSTextCheckingResult] {
                    self.careerLogin = response?.substringWithRange(match.rangeAtIndex(1))
                    if (match.rangeAtIndex(2).location != NSNotFound) {
                        self.email = response?.substringWithRange(match.rangeAtIndex(3))
                        self.school = response?.substringWithRange(match.rangeAtIndex(4))
                        self.campus = response?.substringWithRange(match.rangeAtIndex(5))
                        self.qualifiedName = response?.substringWithRange(match.rangeAtIndex(6))
                    } else {
                        self.school = response?.substringWithRange(match.rangeAtIndex(4))
                        self.campus = response?.substringWithRange(match.rangeAtIndex(5))
                        self.qualifiedName = response?.substringWithRange(match.rangeAtIndex(6))
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimating()
                self.progress.removeFromSuperview()
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        })
        
        self.tableView.rowHeight = 70
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.careerLogin == nil {
            return 0
        } else if self.email == nil {
            return 4
        }
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        
        if self.email != nil {
            if indexPath.row == 0 {
                cell?.textLabel.text = "Career Login"
                cell?.detailTextLabel?.text = self.careerLogin
            } else if indexPath.row == 1 {
                cell?.textLabel.text = "Email"
                cell?.detailTextLabel?.text = self.email
            } else if indexPath.row == 2 {
                cell?.textLabel.text = "School"
                cell?.detailTextLabel?.text = self.school
            } else if indexPath.row == 3 {
                cell?.textLabel.text = "Campus"
                cell?.detailTextLabel?.text = self.campus
            } else if indexPath.row == 4 {
                cell?.textLabel.text = "Qualified Name"
                cell?.detailTextLabel?.text = self.qualifiedName
            }
        } else {
            if indexPath.row == 0 {
                cell?.textLabel.text = "Career Login"
                cell?.detailTextLabel?.text = self.careerLogin
            } else if indexPath.row == 1 {
                cell?.textLabel.text = "School"
                cell?.detailTextLabel?.text = self.school
            } else if indexPath.row == 2 {
                cell?.textLabel.text = "Campus"
                cell?.detailTextLabel?.text = self.campus
            } else if indexPath.row == 3 {
                cell?.textLabel.text = "Qualified Name"
                cell?.detailTextLabel?.text = self.qualifiedName
            }
        }
        
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
