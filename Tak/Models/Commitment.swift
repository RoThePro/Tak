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
    @NSManaged var date: NSDate?
    @NSManaged var deadline: NSDate?
    
    
    func finishCommitment(){
        println(self)
    }
    

}