//
//  LoginViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/21/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var signupPass: UITextField! {didSet { signupPass.delegate = self; setTextFieldStyle(signupPass)} }
    @IBOutlet weak var passConf: UITextField! {didSet { passConf.delegate = self; setTextFieldStyle(passConf)} }
    @IBOutlet weak var usernameSignup: UITextField! {didSet { usernameSignup.delegate = self; setTextFieldStyle(usernameSignup)} }
    @IBOutlet weak var nameSignup: UITextField! {didSet { nameSignup.delegate = self; setTextFieldStyle(nameSignup)} }
    @IBOutlet weak var usernameField: UITextField! {didSet { usernameField.delegate = self; setTextFieldStyle(usernameField)} }
    @IBOutlet weak var passwordField: UITextField! {didSet { passwordField.delegate = self; setTextFieldStyle(passwordField)} }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBAction func loginPressed(sender: AnyObject) {
        if(!usernameField.text.isEmpty || !passwordField.text.isEmpty){
            PFUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text) { (user: PFUser?, error:NSError?) -> Void in
                if(error == nil){
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                        if(result){
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }else{
                            self.showController("Could not register device. Please retry.")
                        }
                    })
                }else{
                    self.showController("Whoops. Could not login.")
                }
            }
        }else{
            showController("Please fill out all fields.")
        }
       
    }
    
    @IBAction func signupPressed(sender: AnyObject) {
        if(!usernameSignup.text.isEmpty || !nameSignup.text.isEmpty || !signupPass.text.isEmpty || !passConf.text.isEmpty){
            if(signupPass.text == passConf.text){
                var user = PFUser()
                user.username = usernameSignup.text
                user.password = signupPass.text
                user["name"] = nameSignup.text
                user.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if(success){
                        let installation = PFInstallation.currentInstallation()
                        installation["user"] = PFUser.currentUser()
                        installation.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) -> Void in
                            if(result){
                                self.performSegueWithIdentifier("loginSegue", sender: self)
                            }else{
                                self.showController("Could not register device, please login to reregister.")
                            }
                        })
                    }else{
                        self.showController("Could not signup. Please retry")
                    }
                })
            }
        }else{
            showController("Please fill out all fields")
        }
    }
    @IBAction func loginToggle(sender: AnyObject) {
        loginView.hidden = !loginView.hidden
        if(!signupView.hidden){
            signupView.hidden = true
        }
        if(!signupView.hidden){
            logo.hidden = true
        }else{
            logo.hidden = false
        }
    }
    
    @IBAction func signupToggle(sender: AnyObject) {
        signupView.hidden = !signupView.hidden
        if(!loginView.hidden){
            loginView.hidden = true
        }
        if(!signupView.hidden){
            logo.hidden = true
        }else{
            logo.hidden = false
        }
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.hidden = true
        signupView.hidden = true
        
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() != nil){
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showController(message: String){
        var alert: UIAlertController = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            println("OK")
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        println("Unwinded")
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
