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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(test)
        
        self.view.backgroundColor = UIColor(red: 4/10, green:4/10, blue:4/10, alpha:1.0)

        // Do any additional setup after loading the view.
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
