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
    
    @IBOutlet weak var logo: UIImageView!
    @IBAction func loginWithFacebookAction(sender: AnyObject) {
        
        var permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    var fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.width(200).height(200)"])
                    fbGraphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
                        var results = result as! NSDictionary
                        user["name"] = results["name"]
                        user["email"] = results["email"]
                        var picture = results["picture"]!["data"] as! NSDictionary
                        var url = picture["url"] as! String
                        var pictureObj = NSURL(string: url)
                        var data = NSData(contentsOfURL: pictureObj!)
                        var imageFile = PFFile(data: data!)
                        user["picture"] = imageFile
                        user.save()
                        user.save()
                    })
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                        println(error ?? "It's cool")
                    })
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                } else {
                    println("User logged in through Facebook!")
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                        println(error ?? "It's cool")
                    })
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //logo.set
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() != nil){
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        println("Unwinded")
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
