//
//  StudentsTableViewController.swift
//  ISeeU-App
//
//  Created by Мануэль on 20.03.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController
{
    var manager = Manager.sharedInstance()
      
    @IBAction func refresh(sender: UIBarButtonItem) {
        manager.refresh(caller: self)
    }
    
    @IBAction func addNewPin(sender: UIBarButtonItem) {
        manager.addNewPin(caller: self)
    }
   
    @IBAction func logout(sender: UIBarButtonItem) {
        manager.logout(caller: self)
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return manager.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! StudentTableViewCell
        
        let student = Student(fromDictionary: manager.students[indexPath.row])
        
        let firstName = student.firstName!
        let lastName = student.lastName!
        
        cell.studentNameLabel.text = "\(firstName) \(lastName)"
        cell.button.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let app = UIApplication.sharedApplication()
        let url = manager.students[indexPath.row]["mediaURL"] as? String
        
        guard let link = url where url!.containsString("https://") else { return }
        
        app.openURL(NSURL(string: link)!)
    }    
}
