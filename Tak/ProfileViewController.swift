//
//  ProfileSettingsViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/29/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var userHelper: User?
    
    override func viewDidLoad() {
        userHelper = User()
        userHelper?.getUser({ (result: PFObject?, error: NSError?) -> Void in
            self.profileImageView.image = UIImage(data: result!["picture"]!.getData()!)
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
            self.profileImageView.layer.masksToBounds = true
            self.profileImageView.layer.borderWidth = 0;
        })
        
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
