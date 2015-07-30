//
//  DatePickerViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/27/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var state: String!
    var date: NSDate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = NSDate()
        if(date != nil){
            datePicker.date = date!
        }else{
            datePicker.date = NSDate()
        }
        
        self.view.backgroundColor = UIColor.clearColor()

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let source = segue.destinationViewController as! NewItemViewController
        source.state = state!
        source.date = datePicker.date
    }
}
