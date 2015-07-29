//
//  ProfileViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/21/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class ProfileSettingsViewController: UIViewController {
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock({(error) -> Void in
            
            if (error != nil){
                println(error)
            }else{
                var alert = UIAlertController(title: "Success", message: "You are now logged out", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                    self.performSegueWithIdentifier("logoutSegue", sender: self)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
