//
//  ChatViewController.swift
//  chatApp
//
//  Created by Thomas Le on 10/29/18.
//  Copyright © 2018 Thomas Le. All rights reserved.
//

import UIKit
import Parse 

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageInput: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [PFObject]()
    
    @IBAction func Send(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageInput.text ?? ""
        chatMessage["user"] = PFUser.current()
        //chatMessage["username"] = PFUser.current()?.username
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        messageInput.text = "" //clears message after chat saved
    }
    
    //this methods run before screen even loads...like prerequisites
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

    }
    
    // Add code to be run periodically here
    @objc func onTimer() {
        //these are parameters, what you're looking to include when you query
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        
        //like pressing enter in the search, actually querying here
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if let objects = objects {
                self.messageArray = objects
                self.tableView.reloadData() // call reload data here so that it's called only when your findObjectsInBackground finishes
            }
            
        }
    }

    //number of cell rows (required for UITableViewDataSource)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //which cell goes in which row (required for UITableViewDataSource)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.chatMessageLabel.text = messageArray[indexPath.row]["text"] as! String?
        
        if let user = messageArray[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
            
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
