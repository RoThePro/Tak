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

class FeedTableViewController: UITableViewController, UIGestureRecognizerDelegate, UITabBarControllerDelegate{
    
    //Helps query database
    var commit: Commit?
    //Array to store queried info
    var objects = [Commitment]()
    var testObjects = [NSDate:[Commitment]]()
    var days = [NSDate]()
    var currentCommitment: Commitment?
    var origin: CGPoint = CGPointZero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
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
        
        
        
        //Makes border between cells clear
        tableView.bounces = false
        tableView.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        //tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor=UIColor.clearColor()
    }
    
    /*func handleAction(recognizer: UIPanGestureRecognizer){
        var startLocation: CGPoint = recognizer.locationInView(self.tableView)
        var velocity: CGPoint = recognizer.velocityInView(self.tableView)
        var indexPath: NSIndexPath!
        
        if(recognizer.state == UIGestureRecognizerState.Changed){
            indexPath = self.tableView.indexPathForRowAtPoint(startLocation)
            if(indexPath != nil){
                var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
                if(origin == CGPointZero){
                    origin = cell.cellView.frame.origin
                }
                var original = cell.cellView.frame.origin
                var cellTranslation = recognizer.translationInView(self.tableView)
                if(cellTranslation.x < 0){
                    cell.cellView.frame = CGRect(x: original.x + cellTranslation.x + 5, y: original.y, width: cell.cellView.frame.width, height: cell.cellView.frame.height)
                }
                recognizer.setTranslation(CGPointZero, inView: self.tableView)
                if(CGPoint(x: cell.cellView.frame.origin.x - origin.x, y: cell.cellView.frame.origin.y - origin.y).x < -(cell.cellView.frame.width/4)){
                    var alert: UIAlertController = UIAlertController(title: "Are you sure you want to delete?", message:"", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                        self.tableView.beginUpdates()
                        self.commit?.deleteCommitment(self.testObjects[self.days[indexPath!.section]]![indexPath!.row])
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
                                
                                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
                                self.tableView.reloadData()
                                self.tableView.endUpdates()
                            } else {
                                println("YOU RETARD")
                            }
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                        println("OK")
                        if(indexPath != nil){
                            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
                            cell.cellView.frame.origin = self.origin
                        }
                        
                    }))
                    
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
//        if(recognizer.state == UIGestureRecognizerState.Ended){
//            indexPath = self.tableView.indexPathForRowAtPoint(startLocation)
//            if(indexPath != nil){
//                var finalPoint = CGPointMake(translation.x, translation.y)
//                if(finalPoint.x < -100){
//                    var alert: UIAlertController = UIAlertController(title: "Are you sure you want to delete?", message:"", preferredStyle: UIAlertControllerStyle.Alert)
//                    
//                    alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) -> Void in
//                        self.tableView.beginUpdates()
//                        self.commit?.deleteCommitment(self.testObjects[self.days[indexPath!.section]]![indexPath!.row])
//                        self.commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
//                            if let commitments = results as? [Commitment] {
//                                self.testObjects = Dictionary()
//                                self.days = []
//                                for commitment in commitments{
//                                    self.testObjects[commitment["date"] as! NSDate]=[]
//                                }
//                                for commitment in commitments{
//                                    self.testObjects[commitment["date"] as! NSDate]!.append(commitment)
//                                    self.days.append(commitment["date"] as! NSDate)
//                                }
//                                
//                                func AscendingNSDate(s1: NSDate, s2: NSDate) -> Bool {
//                                    var earlier = s1.earlierDate(s2)
//                                    if earlier == s1 {
//                                        return true
//                                    }
//                                    return false
//                                }
//                                
//                                self.days = sorted(self.days, AscendingNSDate)
//                                
//                                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
//                                self.tableView.reloadData()
//                                self.tableView.endUpdates()
//                            } else {
//                                println("YOU RETARD")
//                            }
//                        })
//                    }))
//                    alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) -> Void in
//                        println("OK")
//                        if(indexPath != nil){
//                            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FeedTableViewCell
//                            cell.cellView.frame.origin = self.origin
//                        }
//                        
//                    }))
//                    
//                    presentViewController(alert, animated: true, completion: nil)
//                    
//                }else if(finalPoint.x > 100){
//                    println("Swipe left @\(indexPath!.row)")
//                }else if(finalPoint.y != 0){
//                    //self.tableView.removeGestureRecognizer(self.swipe)
//                }
//            }else{
//                println("Select a cell dummy")
//            }
//            
//        }
        
    }*/
    
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
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
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
        
        switch impFactor{
        case 1.0:
            cell.backgroundColor = UIColor(red:0.733, green:0.871, blue:0.984, alpha:1)
        case 2.0:
            cell.backgroundColor = UIColor(red:0.129, green:0.588, blue:0.953, alpha:1)
        case 3.0:
            cell.backgroundColor = UIColor(red:0.098, green:0.463, blue:0.824, alpha:1)
        default:
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    
    
    var test: UITableViewRowActionStyle = UITableViewRowActionStyle.Default
    
    // Override to support editing the table view.
    // Refer to http://pablin.org/2014/09/25/uitableviewrowaction-introduction/
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.currentCommitment = self.testObjects[self.days[indexPath.section]]![indexPath.row]
            //self.performSegueWithIdentifier("editCommitment", sender: self)
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
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    tableView.reloadData()
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
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if(viewController is NavigationController){
            self.performSegueWithIdentifier("Add", sender: nil)
            return false
        }else{
            return true
        }
    }

    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            switch identifier{
            case "Save":
                let source = segue.sourceViewController as! NewItemViewController

                commit?.getCommitments({ (results:[AnyObject]?, error:NSError?) -> Void in
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


