//
//  FeedTableViewController.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/6/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//
//    func rohanssorted(integers: [Int], function: (Int, Int) -> Bool ) {
//        for integer in integers {
//            var booleanResult = function(integer, integer)
//        }
//    }

import UIKit
import Parse

class FeedTableViewController: UITableViewController{
    
    //Helps query database
    var commit: Commit?
    //Array to store queried info
    var objects = [Commitment]()
    var testObjects = [NSDate:[Commitment]]()
    var days = [NSDate]()
    var currentCommitment: Commitment?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Init query helper
        commit = Commit()
        //Gets data from database
        commit?.getCommitments({(results:[AnyObject]?, error:NSError?) -> Void in
            if let commitments = results as? [Commitment] {
                for commitment in commitments{
                    self.testObjects[commitment["date"] as! NSDate]=[]
                }
                for commitment in commitments{
                    self.testObjects[commitment["date"] as! NSDate]!.append(commitment)
                    self.days.append(commitment["date"] as! NSDate)
                }
                
                func AscendingNSDate(s1: NSDate, s2: NSDate) -> Bool {
                    var earlier = s1.earlierDate(s2)
                    if earlier == s1 {
                        return true
                    }
                    return false
                }
                
                self.days = sorted(self.days, AscendingNSDate)
                
                self.objects = commitments
                //println(self.days)
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
        if(!self.days.isEmpty){
            var tempDays = Set(days)
            //println(tempDays.count)
            days = Array(tempDays)
            func AscendingNSDate(s1: NSDate, s2: NSDate) -> Bool {
                var earlier = s1.earlierDate(s2)
                if earlier == s1 {
                    return true
                }
                return false
            }
            
            days = sorted(days, AscendingNSDate)
            return tempDays.count
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(days.count != 0){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate((days[section]))
        }
        return nil
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(!days.isEmpty){
            return testObjects[days[section]]!.count
        }
        
        return 0
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        var object=[Commitment]()
        if(days.count != 0){
            //println(indexPath.section)
            object = testObjects[days[indexPath.section]]!
        }
        //println(object)
        //println(days)
        
        cell.titleLabel.text=object[indexPath.row]["title"] as? String
        cell.descLabel.text=object[indexPath.row]["desc"] as? String
        var impFactor = object[indexPath.row]["impFactor"]! as! Double
        cell.impLabel.text=String(stringInterpolationSegment: impFactor)
        
        switch impFactor{
        case 1.0:
            cell.backgroundColor = UIColor.yellowColor()
        case 2.0:
            cell.backgroundColor = UIColor.orangeColor()
        case 3.0:
            cell.backgroundColor = UIColor.redColor()
        default:
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    // Refer to http://pablin.org/2014/09/25/uitableviewrowaction-introduction/
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.currentCommitment = self.testObjects[self.days[indexPath.section]]![indexPath.row]
            self.performSegueWithIdentifier("editCommitment", sender: self)
        })
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            tableView.beginUpdates()
            self.commit?.deleteCommitment(self.testObjects[self.days[indexPath.section]]![indexPath.row])
            self.commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
                if let commitments = results as? [Commitment] {
                    self.testObjects = Dictionary()
                    self.days = []
                    for commitment in commitments{
                        self.testObjects[commitment["date"] as! NSDate]=[]
                    }
                    for commitment in commitments{
                        self.testObjects[commitment["date"] as! NSDate]!.append(commitment)
                        self.days.append(commitment["date"] as! NSDate)
                    }
                    
                    func AscendingNSDate(s1: NSDate, s2: NSDate) -> Bool {
                        var earlier = s1.earlierDate(s2)
                        if earlier == s1 {
                            return true
                        }
                        return false
                    }
                    
                    self.days = sorted(self.days, AscendingNSDate)
                    
                    //tableView.deleteSections(<#sections: NSIndexSet#>, withRowAnimation: <#UITableViewRowAnimation#>)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    tableView.endUpdates()
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
        currentCommitment = self.testObjects[self.days[indexPath.section]]![indexPath.row]
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
                commit?.getCommitments
                commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let commitments = results as? [Commitment] {
                        for commitment in commitments{
                            self.testObjects[commitment["date"] as! NSDate]=[]
                        }
                        for commitment in commitments{
                            self.testObjects[commitment["date"] as! NSDate]!.append(commitment)
                            self.days.append(commitment["date"] as! NSDate)
                        }
                        
                        func AscendingNSDate(s1: NSDate, s2: NSDate) -> Bool {
                            var earlier = s1.earlierDate(s2)
                            if earlier == s1 {
                                return true
                            }
                            return false
                        }
                        
                        self.days = sorted(self.days, AscendingNSDate)
                        self.tableView.reloadData()
                    } else {
                        println("Error")
                    }
                })
            default:
                println("I don't care about you......")
            }
        }
    }
    
}
