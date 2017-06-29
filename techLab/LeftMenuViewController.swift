//
//  LeftMenuViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var classesNames = [String]()
    let reference = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Left Menu") as? LeftMenuClassesTableViewCell {
            cell.configureCell(classNameValue: classesNames[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "classSelected" {
            if let classViewController = segue.destination as? ClassMessagesViewController {
                if let className = sender as? String {
                    classViewController.className = className
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if classesNames[indexPath.row] == "Main" {
            performSegue(withIdentifier: "mainSelected", sender: nil)
        }
        else if classesNames[indexPath.row] == "FAQ" {
            performSegue(withIdentifier: "FAQSelected", sender: nil)
        }
        else {
            performSegue(withIdentifier: "classSelected", sender: classesNames[indexPath.row])
        }
    }
    
    func downloadData() {
        reference.child("Users").child(userUIDConstant!).child("Classes").observeSingleEvent(of: .value, with: { (snapshot) in
            self.classesNames.removeAll()
            self.classesNames.append("Main")
            if let dictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let classes = Classes(dictionary: dictionary)
                for className in classes.className {
                    self.classesNames.append(className)
                }
            }
            self.classesNames.append("FAQ")
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addClassButtonClicked(_ sender: Any) {
        var className: String!
        var addClassCode: String!
        let reference = FIRDatabase.database().reference()
        let alert = UIAlertController(title: "Add Class", message: "Please enter the code for the class you want to add.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            addClassCode = textField.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add Class", style: .default, handler: { [weak alert] (_) in
            addClassCode = alert?.textFields![0].text
            reference.child("Classes").observeSingleEvent(of: .value, with: { (snapshot) in
                for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    if snap.key == addClassCode {
                        className = snap.value as! String
                    }
                }
                reference.child("Users").child(userUIDConstant!).child("Classes").updateChildValues([className!: true])
                self.downloadData()
            })
        }))
       present(alert, animated: true, completion: nil)
    }
    
    
}
