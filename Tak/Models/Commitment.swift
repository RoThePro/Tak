//
//  Commitment.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/14/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class Commitment: PFObject, PFSubclassing{
    
    override init(){
        super.init()
    }
    
    static func parseClassName() -> String {
        return "Commitment"
    }
    
    override class func initialize(){
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken){
            self.registerSubclass()
        }
    }
    
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var impFactor: NSNumber?
    @NSManaged var user: PFUser?
    @NSManaged var deadline: NSDate?
    
    
    /*func uploadCommitment(title: String, desc: String, imp: Double){
        var commit = PFObject(className:className)
        commit["title"] = title
        commit["desc"] = desc
        commit["impFactor"] = imp
        commit["user"] = user
        commit.saveInBackgroundWithBlock(nil)
    }
    
    func getCommitmentCount()->Int{
        var num: Int
        var query = PFQuery(className: className)
        query.whereKey("user", equalTo: user!)
        num = query.countObjects()
        return num
    }
    
    func getCommitment() -> [PFObject]?{
        var returnObj: [PFObject]?
        var query = PFQuery(className:className)
        query.whereKey("user", equalTo: user!)
        //query.whereKey("user", equalTo: "Hello")
        let response = query.findObjects()
        if response != nil{
            returnObj=response as? [PFObject]
        } else {
            println("Error")
        }
        /*
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                returnObj=objects as? [PFObject]
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                returnObj=nil
            }
        }*/
        return returnObj
    }*/

}