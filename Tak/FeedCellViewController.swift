//
//  FeedCellViewController.swift
//  HelpMinder
//
//  Created by Rohan Bharadwaj on 7/10/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit

class FeedCellViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBOutlet weak var dateField: UITextField! {didSet { dateField.delegate = self; setTextFieldStyle(dateField)} }
    @IBOutlet weak var titleField: UITextField! { didSet { titleField.delegate = self; setTextFieldStyle(titleField)} }
    @IBOutlet weak var descField: UITextField! { didSet { descField.delegate = self; setTextFieldStyle(descField)} }
    @IBOutlet weak var imp: UISlider!
    @IBAction func impAction(sender: AnyObject) {
        imp.value=round(imp.value)
    }
    
    var commitment: Commitment?
    var commit: Commit?
    var date: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commit = Commit()
        //println(test)
        if(commitment != nil){
            titleField.text = commitment!.title
            descField.text = commitment!.desc
            date = commitment!.date
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateField.text = dateFormatter.stringFromDate(commitment!.date!)
            imp.value = commitment!.impFactor as! Float
        }
        
        self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)

        // Do any additional setup after loading the view.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="Save"){
            commit!.editCommitment(titleField.text, desc: descField.text, imp: imp.value as NSNumber, date: date!, commit: commitment!)
        }
    }

    
}
