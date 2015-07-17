//
//  FeedTableViewController.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/6/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController{
    
    //Helps query database
    var commit: Commit?
    //Array to store queried info
    var objects: [Commitment]?
    var currentCommitment: Commitment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Init query helper
        commit = Commit()
        //Gets data from database
        commit?.getCommitments({(results:[AnyObject]?, error:NSError?) -> Void in
            if let commitments = results as? [Commitment] {
                self.objects = commitments
                self.tableView.reloadData()
            } else {
                // Handle error
            }
        })
        
        //Gets number of rows
        //Makes border between cells clear
        //tableView.separatorColor=UIColor.clearColor()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.objects != nil){
            return objects!.count
        }else{
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        var object = objects![indexPath.row]
        
        cell.titleLabel.text=object["title"] as? String
        cell.descLabel.text=object["desc"] as? String
        var impFactor = object["impFactor"]! as! Double
        cell.impLabel.text=String(stringInterpolationSegment: impFactor)
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    // Refer to http://pablin.org/2014/09/25/uitableviewrowaction-introduction/
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.currentCommitment = self.objects![indexPath.row]
            self.performSegueWithIdentifier("editCommitment", sender: self)
        })
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.commit?.deleteCommitment(self.objects![indexPath.row])
            self.commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
                if let commitments = results as? [Commitment] {
                    self.objects = commitments
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                } else {
                    println("YOU RETARD")
                }
            })
        })
        editAction.backgroundColor=UIColor.blueColor()
        return [deleteAction, editAction]
        //return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCommitment = objects![indexPath.row]
        self.performSegueWithIdentifier("feedViewSegue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="feedViewSegue"){
            var svc = segue.destinationViewController as! FeedCellViewController
            svc.commitment=currentCommitment!
        } else if(segue.identifier == "newCommitment"){
            var svc = segue.destinationViewController as! NewItemViewController
            svc.state="New"
        } else if(segue.identifier == "editCommitment"){
            var svc = segue.destinationViewController as! NewItemViewController
            svc.commitment=currentCommitment!
            svc.state="Edit"
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            switch identifier{
            case "Save":
                let source = segue.sourceViewController as! NewItemViewController
                commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let commitments = results as? [Commitment] {
                        self.objects = commitments
                        self.tableView.reloadData()
                    } else {
                        // Handle error
                    }
                })
            default:
                println("I don't care about you......")
            }
        }
    }
    
}
