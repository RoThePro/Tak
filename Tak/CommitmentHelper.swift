//
//  CommitmentHelper.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/15/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class Commit{
    
    var commitment = Commitment()
    
    var className = "Commitment"
    
    var user: PFUser?
    
    init(){
        self.user=PFUser.currentUser()
    }
    
    func uploadCommitment(title: String, desc: String, imp: NSNumber, date: NSDate){
        commitment.title=title
        commitment.desc = desc
        commitment.impFactor = imp
        commitment.user = PFUser.currentUser()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = cal!.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: date)
        let newDate = cal!.dateFromComponents(components)
        let finalDate = cal!.dateByAddingUnit(NSCalendarUnit.CalendarUnitHour, value: 24, toDate: newDate!, options: nil)
        commitment.date = newDate
        commitment.deadline = finalDate
        
        commitment.save()
    }
    
    func finishCommitment(commit: Commitment){
        var query = PFQuery(className: className)
        var commitment = query.getObjectWithId(commit.objectId!)
        if let commitment = commitment{
            commitment.removeObjectForKey("deadline")
            commitment.save()
        }
    }
    
    func procrastinatedCommitments(callback: PFArrayResultBlock){
        var query = PFQuery(className: className)
        query.orderByAscending("date")
        query.whereKey("user", equalTo: user!)
        query.whereKey("procrastinated", equalTo: true)
        query.findObjectsInBackgroundWithBlock(callback)
    }
    
    func getCommitments(callback: PFArrayResultBlock) {
        var query = PFQuery(className:className)
        query.orderByDescending("createdAt")
        query.whereKey("user", equalTo: user!)
        query.whereKeyExists("deadline")
        query.findObjectsInBackgroundWithBlock(callback)
    }
    
    func editCommitment(title: String, desc: String, imp: NSNumber,date: NSDate, commit: Commitment){
        var query = PFQuery(className: className)
        var commitment = query.getObjectWithId(commit.objectId!)
        if let commitment = commitment{
            commitment["title"] = title
            commitment["desc"] = desc
            commitment["impFactor"] = imp
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = cal!.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: date)
            let newDate = cal!.dateFromComponents(components)
            let finalDate = cal!.dateByAddingUnit(NSCalendarUnit.CalendarUnitHour, value: 24, toDate: newDate!, options: nil)
            commitment["date"] = newDate
            commitment["deadline"] = finalDate

            commitment.save()
        }
    }
    
    func deleteCommitment(commit: Commitment){
//        var query = PFQuery(className: className)
//        var commitment = query.getObjectWithId(commit.objectId!)
//        if let commitment = commitment{
//            commitment.removeObjectForKey("deadline")
//            commitment.save()
//        }
        commit.delete()
    }
}