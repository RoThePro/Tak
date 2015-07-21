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
    
    func uploadCommitment(title: String, desc: String, imp: NSNumber){
        commitment.title=title
        commitment.desc = desc
        commitment.impFactor = imp
        commitment.user = PFUser.currentUser()
        
        commitment.save()
    }
    
    func getCommitments(callback: PFArrayResultBlock) {
        var query = PFQuery(className:className)
        query.orderByDescending("createdAt")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock(callback)
    }
    
    func editCommitment(title: String, desc: String, imp: NSNumber, commit: Commitment){
        var query = PFQuery(className: className)
        var commitment = query.getObjectWithId(commit.objectId!)
        if let commitment = commitment{
            commitment["title"] = title
            commitment["desc"] = desc
            commitment["impFactor"] = imp
            commitment.save()
        }
    }
    
    func deleteCommitment(commit: Commitment){
        commit.delete()
    }
}