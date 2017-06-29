//
//  FAQViewController.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FAQViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var questions = [FAQ]()
    var questionKeys = [String]()
    var titleButtonCenter: CGPoint!
    var textButtonCenter: CGPoint!
    var cameraButtonCenter: CGPoint!
    var addQuestionButtonTapped = false
    var imagePicker = UIImagePickerController()
    var titleText: String!
    var messageText: String!
    var currentSelectionQuestionProperty: String?
    let reference = FIRDatabase.database().reference()
    let formatter = DateFormatter()
    var textBackgroundViewPresent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        formatter.dateFormat = "M/dd/yy"
        titleButtonCenter = titleButton.center
        textButtonCenter = textButton.center
        cameraButtonCenter = cameraButton.center
        titleButton.contentMode = .scaleAspectFit
        textButton.contentMode = .scaleAspectFit
        cameraButton.contentMode = .scaleAspectFit
        textButton.layer.cornerRadius = textButton.frame.width * 0.5
        titleButton.layer.cornerRadius = titleButton.frame.width * 0.5
        cameraButton.layer.cornerRadius = cameraButton.frame.width * 0.5
        addQuestionButton.alpha = 1
        addQuestionButtonTapped = false
        imagePicker.delegate = self
        textBackgroundView.alpha = 0
        textBackgroundViewPresent = false
        resetButtons()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.tableView.addGestureRecognizer(swipeDown)
        currentSelectionQuestionProperty = ""
        downloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let addPoint = CGPoint(x: self.titleButtonCenter.x, y: (self.addQuestionButton.superview?.center.y)!)
        titleButton.center = addPoint
        titleButton.alpha = 0
        textButton.center = addPoint
        textButton.alpha = 0
        cameraButton.center = addPoint
        cameraButton.alpha = 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Question Cell") as? FAQQuestionsTableViewCell {
            cell.configureCell(questionObject: questions[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.row]
        performSegue(withIdentifier: "questionSelected", sender: question)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionSelected" {
            if let senderObject = sender as? FAQ {
                if let destinationViewController = segue.destination as? AnswerQuestionViewController {
                    destinationViewController.question = senderObject
                }
            }
        }
    }
    @IBAction func addQuestionButtonClicked(_ sender: UIButton) {
        addQuestionButtonTapped = !addQuestionButtonTapped
        if addQuestionButtonTapped == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.moveButtons()
            })
        }
        else {
            if titleText != "" && messageText != "" && titleText != nil && messageText != nil{
                let message = messageText
                let currentTime = formatter.string(from: Date())
                let name = firstNameConstant! + " " + lastNameConstant!
                let userUID = userUIDConstant
                let title = titleText
                let questionKey = reference.child("Messages").child("FAQ").childByAutoId().key
                let questionDictionary = ["name": name, "message": message, "title": title, "userUID": userUID, "time": currentTime, "questionKey": questionKey] as Dictionary<String, AnyObject>
                sendData(dictionary: questionDictionary , questionKey: questionKey)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.resetButtons()
            })
        }
    }

    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        currentSelectionQuestionProperty = "Camera"
        chooseImage()
        currentSelectionQuestionProperty = ""
    }
    
    @IBAction func textButtonClicked(_ sender: Any) {
        if currentSelectionQuestionProperty == "" || currentSelectionQuestionProperty == "Message" {
            if textBackgroundViewPresent == true {
                textBackgroundViewPresent = false
                UIView.animate(withDuration: 0.3) {
                    self.textBackgroundView.alpha = 0
                }
            }
            else {
                textBackgroundViewPresent = true
                UIView.animate(withDuration: 0.3) {
                    self.textBackgroundView.alpha = 1
                }
            }
            currentSelectionQuestionProperty = "Message"
            textTextField.placeholder = "question"
        }
        else {
            currentSelectionQuestionProperty = "Message"
            textTextField.placeholder = "question"
        }
        
        
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        if currentSelectionQuestionProperty == "" || currentSelectionQuestionProperty == "Title" {
            if textBackgroundViewPresent == true {
                textBackgroundViewPresent = false
                UIView.animate(withDuration: 0.3) {
                    self.textBackgroundView.alpha = 0
                }
            }
            else {
                textBackgroundViewPresent = true
                UIView.animate(withDuration: 0.3) {
                    self.textBackgroundView.alpha = 1
                }
            }
            currentSelectionQuestionProperty = "Title"
            textTextField.placeholder = "title"

        }
        else {
            currentSelectionQuestionProperty = "Title"
            textTextField.placeholder = "title"

        }
        
    }
    
    func resetButtons() {
        let addPoint = CGPoint(x: self.titleButtonCenter.x, y: (self.addQuestionButton.superview?.center.y)!)
        titleButton.center = addPoint
        titleButton.alpha = 0
        textButton.center = addPoint
        textButton.alpha = 0
        cameraButton.center = addPoint
        cameraButton.alpha = 0
    }
    
    func moveButtons() {
        
        self.titleButton.center = self.titleButtonCenter
        self.titleButton.alpha = 1
        self.textButton.center = self.textButtonCenter
        self.textButton.alpha = 1
        self.cameraButton.center = self.cameraButtonCenter
        self.cameraButton.alpha = 1
    }
    
    func chooseImage() {
        let alert = UIAlertController(title: nil, message: "Please choose how you would like to select the photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
                self.createAlert(message: "Cannot open the camera.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
                self.createAlert(message: "Cannot open the photo library.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            cameraButton.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
        }
        else if info[UIImagePickerControllerOriginalImage] == nil {
            dismiss(animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
            createAlert(message: "Couldn't select photo")
        }
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneTextSelected(_ sender: Any) {
        if currentSelectionQuestionProperty == "Message" {
            messageText = textTextField.text
        }
        else if currentSelectionQuestionProperty == "Title" {
            titleText = textTextField.text
        }
        textBackgroundView.alpha = 0
        textBackgroundViewPresent = false
        view.endEditing(true)
        currentSelectionQuestionProperty = ""
        textTextField.text = ""
    }
    
    func dismissKeyboard() {
        textBackgroundView.isHidden = true
        textBackgroundView.alpha = 0
        view.endEditing(true)
        currentSelectionQuestionProperty = ""
    }
    
    func sendData(dictionary: Dictionary<String, AnyObject>, questionKey: String) {
        reference.child("Messages").child("FAQ").child(questionKey).setValue(dictionary) { (error, reference) in
            if error == nil {
                self.tableView.reloadData()
            }
            else {
                self.createAlert(message: "An error occurred. Please try again later.")
            }
        }
    }
    
    func downloadData () {
        reference.child("Messages").child("FAQ").observe(.value, with: { (snapshot) in
            self.questions.removeAll()
            self.questionKeys.removeAll()
            for snap in snapshot.children.reversed() as! [FIRDataSnapshot] {
                let value = snap.value as? NSDictionary
                self.questionKeys.append(snap.key)
                let questionObject = FAQ(dictionary: value as! Dictionary<String, AnyObject>, questionKey: snap.key)
                self.questions.append(questionObject)
            }
            self.tableView.reloadData()
        })
    }
   
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
        
}
