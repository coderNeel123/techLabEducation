//
//  MainMessagesViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MainMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var messageKeys = [String]()
    var messages = [MainMessages]()
    let reference = FIRDatabase.database().reference()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        formatter.dateFormat = "h:mm a"
        sideMenu()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message Cell") as? MainMessagesTableViewCell {
            cell.customCell(messageObject: messages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            
            settingsButton.target = revealViewController()
            settingsButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.width * 0.80
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func downloadData () {
        reference.child("Messages").child("Main").observe(.value, with: { (snapshot) in
            self.messages.removeAll()
            self.messageKeys.removeAll()
            for snap in snapshot.children.reversed() as! [FIRDataSnapshot] {
                let value = snap.value as? NSDictionary
                self.messageKeys.append(snap.key)
                let messageObject = MainMessages(dictionary: value! as! Dictionary<String, AnyObject> , messagekey: snap.key)
                self.messages.append(messageObject)
            }
            self.tableView.reloadData()
        })

    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Cannot Send", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func sendData(dictionary: Dictionary<String, AnyObject>, messageKey: String) {
        reference.child("Messages").child("Main").child(messageKey).setValue(dictionary) { (error, reference) in
            if error == nil {
                self.tableView.reloadData()
            }
            else {
                self.createAlert(message: "An error occurred. Please try again later.")
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageField.text != "" {
            let message = messageField.text
            let currentTime = formatter.string(from: Date())
            let name = firstNameConstant! + " " + lastNameConstant!
            let userUID = userUIDConstant
            let messageDictionary = ["name": name, "message": message, "time": currentTime, "userUID": userUID] as Dictionary<String, AnyObject>
            let messageKey = reference.child("Messages").child("Main").childByAutoId().key
            sendData(dictionary: messageDictionary , messageKey: messageKey)
            messageField.text = ""
        }
        else {
            createAlert(message: "Please enter a message.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
}
