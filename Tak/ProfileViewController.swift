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
    @IBOutlet weak var tableView: UITableView!
    
    var userHelper: User?
    
    override func viewDidLoad() {
        userHelper = User()
        userHelper?.getUser({ (result: PFObject?, error: NSError?) -> Void in
            self.profileImageView.image = UIImage(data: result!["picture"]!.getData()!)
            self.nameLabel.text = result!["name"] as? String
            self.setPictureDesign(self.profileImageView)
            
            self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPictureDesign(image: UIImageView){
        image.layer.cornerRadius = image.frame.size.height/2
        image.layer.masksToBounds = true
        image.layer.borderWidth = 1;
        image.layer.borderColor = UIColor.whiteColor().CGColor
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

extension ProfileViewController: UITableViewDelegate{
    //tableView
}

extension ProfileViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
