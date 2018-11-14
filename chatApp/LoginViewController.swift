//
//  ViewController.swift
//  chatApp
//
//  Created by Thomas Le on 10/16/18.
//  Copyright © 2018 Thomas Le. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    var titleText = String()
    var messageText = String()
    
    
    func callAlert(titleText: String, messageText: String, style: UIAlertControllerStyle){
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
    }
    
    //NEW USER SIGN UP
    @IBAction func signUpButton(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameInput.text
        newUser.password = passwordInput.text
        
      
        if  (usernameInput.text?.isEmpty)! {
            callAlert(titleText: "Empty Username Input", messageText: "Enter a username", style: .alert)
            print("Enter a username")
        }
            
        else if (passwordInput.text?.isEmpty)! {
            callAlert(titleText: "Empty Password Input", messageText: "Enter a password", style: .alert)
            print("Please Enter Username or password")
        }
        
        else{
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.callAlert(titleText: "Unsuccessful Signup", messageText: "Try another username", style: .alert)
                
            } else {
                print("User Registered successfully")
                self.callAlert(titleText: "Signed up successfully", messageText: "Now Login to enter the app", style: .alert)
                print("signed up successfully")
                // manually segue to logged in view
                
                
            }
        }
        }
    }
    
    
    //LOGIN
    @IBAction func loginButton(_ sender: Any) {
        let username = usernameInput.text
        let password = passwordInput.text
        
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user: PFUser?, error: Error?) in
            if let error = error {
                self.callAlert(titleText: "No username found", messageText: "Try again or sign up first", style: .alert)
                print("User log in failed: \(error.localizedDescription)")
                
            } else {
                //self.callAlert(titleText: "Welcome to Chitchat!", messageText: "Chat Responsibly", style: .alert)
               
                print("User logged in successfully")
                
                //on dismissal of alert
               
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

