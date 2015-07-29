//
//  LoginViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/21/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBAction func loginWithTwitterAction(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in with Twitter!")
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                } else {
                    println("User logged in with Twitter!")
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            } else {
                println(user)
                println("Uh oh. The user cancelled the Twitter login.")
            }
        }
    }
    
    @IBAction func loginWithFacebookAction(sender: AnyObject) {
        
        var permissions = ["public_profile","email"]
        
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError?) -> Void in
                        if(succeeded){
                            var fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"])
                            fbGraphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
                                var results = result as! NSDictionary
                                user["name"] = results["name"]
                                user["email"] = results["email"]
                                user.save()
                            })
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }else{
                            println("Error")
                            println(error)
                        }
                    })
                } else {
                    println("User logged in through Facebook!")
                    let token = FBSDKAccessToken.currentAccessToken()
                    //println(token)
                    if(token.hasGranted("publish_actions")){
                        var fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"])
                        fbGraphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
                            var results = result as! NSDictionary
                            user["name"] = results["name"]
                            user["email"] = results["email"]
                            user.save()
                        })
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }else{
                        PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError?) -> Void in
                            if(succeeded){
                                println("YAY")
                                println(PFUser.currentUser())
                                self.performSegueWithIdentifier("loginSegue", sender: self)
                            }else{
                                println(error)
                                println("Error")
                            }
                        })
                    }
                    
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() != nil){
            println("Works")
            performSegueWithIdentifier("loginSegue", sender: self)
            println("Why?")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
