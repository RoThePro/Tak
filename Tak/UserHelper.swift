//
//  UserHelper.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/29/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import Parse

class User{

    var user: PFUser = PFUser.currentUser()!
    
    
    func getUser(callback: PFObjectResultBlock){
        var query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: user.objectId!)
        query.getFirstObjectInBackgroundWithBlock(callback)
    }
    
}