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
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if(!titleField.text.isEmpty && !descField.text.isEmpty && !dateField.text.isEmpty){
            self.performSegueWithIdentifier("Save", sender: nil)
        }else{
            var alert: UIAlertController = UIAlertController(title: "Empty Fields", message:"Please enter values for Title, Description and Date", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                println("OK")
            }))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var dateField: UITextField! {didSet { dateField.delegate = self; setTextFieldStyle(dateField)} }
    @IBOutlet weak var titleField: UITextField! { didSet { titleField.delegate = self; setTextFieldStyle(titleField)} }
    @IBOutlet weak var descField: UITextField! { didSet { descField.delegate = self; setTextFieldStyle(descField)} }
    @IBOutlet weak var imp: UISlider!
    @IBAction func impAction(sender: AnyObject) {
        imp.value=round(imp.value)
    }
    var commit: Commit?
    //var state: String?
    var commitment: Commitment?
    var date: NSDate?
    
    func setTextFieldStyle(textField: UITextField){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.borderColor = UIColor.clearColor().CGColor
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    @IBAction func datePicker(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.minimumDate = NSDate()
        if(date != nil){
            datePickerView.date = date!
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        date = NSDate()
        dateField.text = dateFormatter.stringFromDate(date!)
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        date = sender.date
        dateField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commit=Commit()
        
        self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("Hello")
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
            commit!.uploadCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber, date: date!)
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
