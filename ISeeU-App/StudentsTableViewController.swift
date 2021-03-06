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
    var manager   = Manager.sharedInstance()
    var dataStore = DataStore.sharedInstance()
      
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
       
        return dataStore.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! StudentTableViewCell
        
        let student = dataStore.students[indexPath.row]
        
        if  let firstName = student.firstName,  let lastName = student.lastName
        {
            cell.studentNameLabel.text = "\(firstName) \(lastName)"
        }
        
        cell.button.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let app = UIApplication.sharedApplication()
        let url = dataStore.students[indexPath.row].mediaURL
        
        guard let link = url where url!.containsString("https://") || url!.containsString("http://") else {
            
            presentViewController(Manager.sharedInstance().errorHandler.showAlert("Whoops..", message: "Invalid url"), animated: true, completion: nil)
         
            return
        }
        
        app.openURL(NSURL(string: link)!)
    }    
}
