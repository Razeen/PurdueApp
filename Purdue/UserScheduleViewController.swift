//
//  UserScheduleViewController.swift
//  Purdue
//
//  Created by George Lo on 1/14/15.
//  Copyright (c) 2015 Purdue University. All rights reserved.
//

import UIKit

class UserScheduleViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pattern: NSString = "<TR>\\s+<TD CLASS=\"dddefault\">.*?</TD>\\s+(<TD CLASS=\"dddefault\">.*?</TD>\\s+)+</TR>"
        let regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL(string: "https://wl.mypurdue.purdue.edu/cp/home/loginf")!), returningResponse: nil, error: nil)
            NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL(string: "https://wl.mypurdue.purdue.edu/cp/home/displaylogin")!), returningResponse: nil, error: nil)
            var postString = NSString(format: "pass=%@&user=%@&uuid=0xACA021", AccountUtils.getPassword()!, AccountUtils.getUsername()!)
            var request = NSMutableURLRequest(URL: NSURL(string: "https://wl.mypurdue.purdue.edu/cp/home/login")!)
            request.HTTPMethod = "POST"
            request.setValue("\(postString.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            
            let request1 = NSMutableURLRequest(URL: NSURL(string: "https://wl.mypurdue.purdue.edu/cp/ip/login?sys=sctssb&url=https://selfservice.mypurdue.purdue.edu/prod/tzwkwbis.P_CheckAgreeAndRedir?ret_code=STU_ACTIVEREG")!)
            request1.setValue("https://wl.mypurdue.purdue.edu/render.UserLayoutRootNode.uP?uP_tparam=utf&utf=%2fcp%2fip%2flogin%3fsys%3dsctssb%26url%3dhttps://selfservice.mypurdue.purdue.edu/prod/tzwkwbis.P_CheckAgreeAndRedir?ret_code=STU_ACTIVEREG", forHTTPHeaderField: "Referer")
            NSURLConnection.sendSynchronousRequest(request1, returningResponse: nil, error: nil)!
            
            var responseData = NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL(string: "https://selfservice.mypurdue.purdue.edu/prod/bwsksreg.p_active_regs")!), returningResponse: nil, error: nil)!
            var decodedData = NSString(data: responseData, encoding: NSUTF8StringEncoding)
            println(decodedData)
            
            dispatch_async(dispatch_get_main_queue(), {
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
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }

        return cell!
    }

}
