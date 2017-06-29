//
//  AnswerQuestionViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AnswerQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleQuestion: UILabel!

    var questionKeys = [String]()
    var comments = [Comments]()
    var question: FAQ!
    let reference = FIRDatabase.database().reference()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "h:mm a"
        questionText.delegate = self
        questionText.isEditable = false
        questionText.text = question.message
        titleQuestion.text = question.title
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        downloadData()
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Comments Cell") as? AnswerQuestionsTableViewCell {
            cell.configureCell(answerObject: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func downloadData() {
        reference.child("Messages").child("Comments").child(question.questionKey).observeSingleEvent(of: .value, with: { (snapshot) in
            self.questionKeys.removeAll()
            self.comments.removeAll()
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let value = snap.value as? NSDictionary
                let comment = Comments(dictionary: value as! Dictionary<String, AnyObject>, questionKey: snap.key)
                self.comments.append(comment)
                self.questionKeys.append(snap.key)
            }
            self.tableView.reloadData()
        })
    }
    
    func sendData(comment: String) {
        let name = firstNameConstant! + " " + lastNameConstant!
        let time = formatter.string(from: Date())
        let commentString = comment
        let dictionary = ["name": name, "time": time, "comment": commentString, "userUID": userUIDConstant!]
        reference.child("Messages").child("Comments").child(question.questionKey).childByAutoId().setValue(dictionary)
        downloadData()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if commentField.text != "" && commentField != nil {
            sendData(comment: commentField.text!)
            commentField.text = ""
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    

}
