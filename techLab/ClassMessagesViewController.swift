//
//  ClassMessagesViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ClassMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var viewLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usersButton: UIBarButtonItem!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var usersView: UIView!
    @IBOutlet weak var usersTableView: UITableView!

    let reference = FIRDatabase.database().reference()
    var className: String!
    var usersViewShowing = false
    var classMessageKeys = [String]()
    var classMessages = [MainMessages]()
    var users = [Users]()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        classNameLabel.text = className
        tableView.delegate = self
        tableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersViewShowing = false
        usersView.layer.shadowOpacity = 1.0
        usersView.layer.shadowColor = UIColor.white.cgColor
        downloadUserData()
        downloadData()
        formatter.dateFormat = "h:mm a"
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        sideMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            revealViewController().rightViewRevealWidth = 200
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
    }
    
    func downloadData () {
        reference.child("Messages").child(className).observe(.value, with: { (snapshot) in
            self.classMessages.removeAll()
            self.classMessageKeys.removeAll()
            for snap in snapshot.children.reversed() as! [FIRDataSnapshot] {
                let value = snap.value as? NSDictionary
                self.classMessageKeys.append(snap.key)
                let messageObject = MainMessages(dictionary: value! as! Dictionary<String, AnyObject> , messagekey: snap.key)
                self.classMessages.append(messageObject)
            }
            self.tableView.reloadData()
        })
        
    }

    @IBAction func clickedUsersButton(_ sender: Any) {
        if usersViewShowing == true {
            viewLeadingConstant.constant = 0
            viewTrailingConstant.constant = 0
            revealViewController().rightViewRevealWidth = 200
        }
        else {
            viewLeadingConstant.constant = -200
            viewTrailingConstant.constant = 200
            revealViewController().rightViewRevealWidth = 0
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        usersViewShowing = !usersViewShowing
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        if messageField.text != "" {
            let message = messageField.text
            let currentTime = formatter.string(from: Date())
            let name = firstNameConstant! + " " + lastNameConstant!
            let userUID = userUIDConstant
            let messageDictionary = ["name": name, "message": message, "time": currentTime, "userUID": userUID] as Dictionary<String, AnyObject>
            let messageKey = reference.child("Messages").child(className).childByAutoId().key
            sendData(dictionary: messageDictionary , messageKey: messageKey)
            messageField.text = ""
            view.endEditing(true)
        }
        else {
            createAlert(message: "Please enter a message.")
        }

    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Cannot Send", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.usersTableView {
            return users.count
        }
        return classMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ClassMessageCell") as? MainMessagesTableViewCell {
                cell.customCell(messageObject: classMessages[indexPath.row])
                return cell
            }
        }
        else if tableView == self.usersTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell") as? UsersTableViewCell {
                cell.configureCell(userObject: users[indexPath.row])
                return cell
            }
        }
		return UITableViewCell()
    }
    
    func downloadUserData() {
        reference.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in (snapshot.children.allObjects as? [FIRDataSnapshot])! {
                if let dictionary = snap.value as? Dictionary<String, AnyObject> {
                    if dictionary["Classes"]?[self.className] as? Bool == true, dictionary["Classes"] != nil && dictionary["Classes"]?[self.className] != nil {
                        let user = Users(dictionary: dictionary)
                        self.users.append(user)
                    }
                }
            }
            self.usersTableView.reloadData()
        })
    }
    
    
    func sendData(dictionary: Dictionary<String, AnyObject>, messageKey: String) {
        reference.child("Messages").child(className).child(messageKey).setValue(dictionary) { (error, reference) in
            if error == nil {
                self.tableView.reloadData()
            }
            else {
                self.createAlert(message: "An error occurred. Please try again later.")
            }
        }
    }
    
    
}
