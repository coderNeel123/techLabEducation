//
//  LoginViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var reference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = FIRDatabase.database().reference()
        
        passwordField.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2)
        emailField.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2)
    }
    
    @IBAction func forgotButtonPressed(_ sender: Any) {
        var resetPasswordEmail: String?
        let alert = UIAlertController(title: "Reset Password", message: "Please enter your email.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            resetPasswordEmail = textField.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { [weak alert] (_) in
            resetPasswordEmail = alert?.textFields![0].text
            FIRAuth.auth()?.sendPasswordReset(withEmail: resetPasswordEmail!, completion: { (error) in
                if error == nil {
                    let alert = UIAlertController(title: "Email Sent", message: "A reset password verification has been sent to \(resetPasswordEmail!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else  {
                    self.createAlert(message: "Something went wrong. Please try again later.")
                }
            })
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if (emailField.text != nil && passwordField.text != nil) {
            loginIntoFirebase(username: emailField.text!, password: passwordField.text!)
        }
        else {
            createAlert(message: "Please enter your email and password")
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUpButtonPressed", sender: nil)
    }
    
    func loginIntoFirebase(username: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
            if error == nil {
                self.reference.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        firstNameConstant = data["firstName"] as? String
                        lastNameConstant = data["lastName"] as? String
                        userUIDConstant = user?.uid
                        emailConstant = data["email"] as? String
                    }
                })
                self.performSegue(withIdentifier: "successfulLogin", sender: nil)
            }
            else {
                switch error?._code {
                    case 17020?:
                        self.createAlert(message: "Network Error")
                    case 17011?:
                        self.createAlert(message: "Incorrect username or password")
                    case 17009?:
                        self.createAlert(message: "Incorrect username or password")
                    default:
                        self.createAlert(message: "An error occured. Please try again later...")
                }
            }
        })
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func selectedPasswordField(_ sender: Any) {
        passwordField.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
    }
    
    @IBAction func selectedEmailField(_ sender: Any) {
        emailField.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2)
    }
}
