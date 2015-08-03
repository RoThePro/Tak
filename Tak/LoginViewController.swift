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
        //PFTwitterUtils.twitter()
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in with Twitter!")
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                } else {
                    println("User logged in with Twitter!")
                    var token : NSString = PFTwitterUtils.twitter()!.authToken!
                    var secret : NSString = PFTwitterUtils.twitter()!.authTokenSecret!
                    var usern : NSString = PFTwitterUtils.twitter()!.screenName!
                    
                    var credential : ACAccountCredential = ACAccountCredential(OAuthToken: token as String, tokenSecret: secret as String)
                    var verify : NSURL = NSURL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=\(usern)")!
                    var request : NSMutableURLRequest = NSMutableURLRequest(URL: verify)
                    
                    //You don't need this line
                    //request.HTTPMethod = "GET"
                    
                    PFTwitterUtils.twitter()!.signRequest(request)
                    
                    //Using just the standard NSURLResponse.
                    var response: NSURLResponse? = nil
                    var error: NSError? = nil
                    var data = NSURLConnection.sendSynchronousRequest(request,
                        returningResponse: &response, error: nil) as NSData?
                    
                    if error != nil {
                        println("error \(error)")
                    } else {
                        //This will print the status code repsonse. Should be 200.
                        //You can just println(response) to see the complete server response
                        //println((response as! NSHTTPURLResponse).statusCode)
                        //Converting the NSData to JSON
                        let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!,
                            options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                        user["name"] = json["name"]!
                        var rawURL = json["profile_image_url"] as! String
                        var url = rawURL.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        var pictureObj = NSURL(string: url)
                        var data = NSData(contentsOfURL: pictureObj!)
                        var imageFile = PFFile(data: data!)
                        user["picture"] = imageFile
                        user.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                            println(error ?? "It's all good")
                        })
                    }
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            } else {
                println(user)
                println("Uh oh. The user cancelled the Twitter login.")
            }
        }
    }
    
    /*@IBAction func loginWithFacebookAction(sender: AnyObject) {
        
        var permissions = ["public_profile","email"]
        
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError?) -> Void in
                        if(succeeded){
                            var fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.width(100).height(100)"])
                            fbGraphRequest.startWithCompletionHandler({(connection, result, error) -> Void in
                                var results = result as! NSDictionary
                                user["name"] = results["name"]
                                user["email"] = results["email"]
                                user["picture"] = results["picture"]
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
                        var fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.width(900).height(900)"])
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
    }*/
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
