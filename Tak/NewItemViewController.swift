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
    
    @IBOutlet weak var dateField: UITextField! {didSet { dateField.delegate = self } }
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
    var date: NSDate?
    
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
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateField.text = dateFormatter.stringFromDate((commitment?.date!)!)
        default:
            return
        }
        
        self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        
        impValue.text="Imp Factor: \(imp.value)"
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("Hello")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == dateField){
            textField.endEditing(true)
            
            performSegueWithIdentifier("datePicker", sender: self)
        }
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
            if(!titleField.text.isEmpty && !descField.text.isEmpty && date != nil){
                if state!=="New"{
                    commit!.uploadCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber, date: date!)
                }else if state!=="Edit"{
                    commit!.editCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber, date: date!, commit: commitment!)
                }
            }else{
                var alert: UIAlertController = UIAlertController(title: "Empty Fields", message:"Please enter values for Title, Description and Date", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                    println("OK")
                }))
                
                presentViewController(alert, animated: true, completion: nil)
            }
        }else if(segue.identifier=="datePicker"){
            let source = segue.destinationViewController as! DatePickerViewController
            source.state = state!
            if(date != nil){
                source.date = date
            }
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if(date != nil){
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateField.text = dateFormatter.stringFromDate(date!)
        }else{
            println("Not set")
        }
    }

}
