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
    @IBOutlet weak var tableViewTitle: UILabel!
    
    var userHelper: User?
    var commit: Commit?
    var objects = [Commitment]()
    
    override func viewDidLoad() {
        userHelper = User()
        commit = Commit()
        userHelper?.getUser({ (result: PFObject?, error: NSError?) -> Void in
            self.profileImageView.image = UIImage(data: result!["picture"]!.getData()!)
            self.nameLabel.text = result!["name"] as? String
            
            self.setPictureDesign(self.profileImageView)
            
            self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        })
        
        commit?.procrastinatedCommitments({ (results: [AnyObject]?, error: NSError?) -> Void in
            if let commitment = results as? [Commitment]{
                self.objects = commitment
                self.tableView.reloadData()
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        //tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor=UIColor.clearColor()
        
        
        tableViewTitle.text = "Procrastinated Tasks"
    
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
    
}

extension ProfileViewController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        cell.backgroundColor = UIColor(red: 4/10, green:4/10, blue: 4/10, alpha: 1.0)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.title.text = objects[indexPath.row].title
        cell.desc.text = objects[indexPath.row].desc
        
        return cell
    }
}
