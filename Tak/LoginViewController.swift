//
//  LoginViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/21/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        if (count(username) < 4 || count(password) < 5) {
            
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 4 and Password must be greater than 5", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }else {
            
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                if ((user) != nil) {
                    
                    var alert = UIAlertController(title: "Success", message: "You are now logged in", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    //self.performSegueWithIdentifier("loginSegue", sender: self)
                    
                }else {
                    
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                }
                
            })
            
        }
        
    }
    
    @IBAction func loginWithFacebookAction(sender: FBSDKButton) {
        
        var permissions = ["public_profile"]
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError?) -> Void in
                        if(succeeded){
                            println("YAY")
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }else{
                            println("Error")
                            println(error)
                        }
                    })
                } else {
                    println("User logged in through Facebook!")
                    let token = FBSDKAccessToken.currentAccessToken()
                    if(token.hasGranted("publish_actions")){
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                    }else{
                    PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError?) -> Void in
                        if(succeeded){
                            println("YAY")
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
        
        if PFUser.currentUser() != nil{
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
        // Do any additional setup after loading the view.
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
