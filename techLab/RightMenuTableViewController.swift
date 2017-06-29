//
//  RightMenuTableViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/13/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation
import MessageUI

class RightMenuTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var userWelecome: UILabel!
    @IBOutlet weak var userInformation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userWelecome.text = "Welcome \(firstNameConstant!)"
        userInformation.text = "\(firstNameConstant!)'s Information"
        name.text = firstNameConstant! + " " + lastNameConstant!
        email.text = emailConstant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        if selectedRow == 3 {
            do {
                try FIRAuth.auth()?.signOut()
                self.performSegue(withIdentifier: "signedOut", sender: nil)
            } catch {
                createAlert(message: "Couldn't sign out. Please try again later.")
            }
        }
        else if selectedRow == 4 {
            let mailController = configuredMailController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailController, animated: true, completion: nil)
            }
            else {
                createAlert(message: "Cannot send mail now")
            }
            
        }
    }
    
    func configuredMailController() -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setToRecipients(["keshav@techlab.edu", "operations@techlab.edu"])
        return mailController
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            createAlert(message: "Couldn't send mail now")
        }
        controller.dismiss(animated: true, completion: nil)
    }

    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
