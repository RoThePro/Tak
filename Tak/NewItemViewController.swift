//
//  NewItemViewController.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/13/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class NewItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField! { didSet { titleField.delegate = self } }
    @IBOutlet weak var descField: UITextField! { didSet { descField.delegate = self } }
    @IBOutlet weak var imp: UISlider!
    @IBOutlet weak var impValue: UILabel!
    @IBAction func impAction(sender: AnyObject) {
        imp.value=round(imp.value)
        impValue.text="Imp Factor: \(imp.value)"
    }
    var commit: Commit?
    var state: String?
    var commitment: Commitment?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commit=Commit()
        switch(state!){
        case "New":
            println("New")
        case "Edit":
            titleField.text=commitment?.title
            descField.text=commitment?.desc
            imp.value=commitment?.impFactor as! Float
        default:
            println("You're a dumbass")
        }
        //UITextField.delegate=self
        
        impValue.text="Imp Factor: \(imp.value)"
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="Save"){
            if state=="New"{
                commit!.uploadCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber)
            }else if state=="Edit"{
                commit!.editCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber, commit: commitment!)
            }
        }
    }
}
