//
//  SignUpViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    let formatter = DateFormatter()
    let reference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMMM dd, YYYY"
        birthdayPicker.setValue(UIColor.init(red: 175/255, green: 175/255, blue: 175/255, alpha: 1), forKeyPath: "textColor")
        firstNameField.layer.addBorder(edge: .bottom, color: UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1), thickness: 2)
        emailField.layer.addBorder(edge: .bottom, color: UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1), thickness: 2)
        passwordField.layer.addBorder(edge: .bottom, color: UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1), thickness: 2)
        lastNameField.layer.addBorder(edge: .bottom, color: UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1), thickness: 2)
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        if formatter.string(from: birthdayPicker.date) != formatter.string(from: Date()) {
            if firstNameField.text != "" && lastNameField.text != "" && emailField.text != "" && passwordField.text != "" {
                createUser(firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!, birthday: formatter.string(from: birthdayPicker.date))
            }
            else {
                createAlert(message: "Please fill out all the fields")
            }
        }
        else {
            createAlert(message: "Please enter your birthday")
        }
    }
    
    func createUser(firstName: String, lastName: String, email: String, password: String, birthday: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let userUID = user?.uid
                let reference = FIRDatabase.database().reference()
                let userInformation = ["firstName": firstName, "lastName": lastName, "email": email, "birthday": birthday, "userUID": userUID]
                reference.child("Users").child(userUID!).setValue(userInformation)
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        self.reference.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let data = snapshot.value as? Dictionary<String, AnyObject> {
                                firstNameConstant = data["firstName"] as? String
                                lastNameConstant = data["lastName"] as? String
                                userUIDConstant = user?.uid
                                emailConstant = data["email"] as? String
                            }
                        })
                        self.performSegue(withIdentifier: "signedUp", sender: nil)
                    }
                    else {
                        self.createAlert(message: "An error occurred when creating your account.")
                    }
                })
            }
            else {
                self.createAlert(message: "An error occurred when creating your account.")
            }
        })
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
   
}
