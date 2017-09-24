//
//  UserDetailsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 08/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var dateOfBirth: TextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveDetailsButton: UIButton!
    @IBOutlet weak var activityView1: UIActivityIndicatorView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var notificationTimeField: TextField!
    
    let datePicker : UIDatePicker = UIDatePicker()
    let timePicker : UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //delegates
        nameTextField.delegate = self
        dateOfBirth.delegate = self
        
        //datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDateChange(sender:)), for: UIControlEvents.valueChanged)
        
        //timePicker
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(handleTimeChange(sender:)), for: UIControlEvents.valueChanged)
        
        //activityIndicatorView
        addActivityViewController(activityView, true)
        
        //datePickerToolbar
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barStyle = .default
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resign(sender:)))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor =  UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        toolbar.sizeToFit()
        
        //timePickerToolbar
        let timeToolbar = UIToolbar()
        timeToolbar.isTranslucent = false
        timeToolbar.barStyle = .default
        let timeDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignTime(sender:)))
        timeToolbar.setItems([timeDoneButton], animated: true)
        timeToolbar.isUserInteractionEnabled = true
        timeToolbar.tintColor =  UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        timeToolbar.sizeToFit()
        
        dateOfBirth.inputView = datePicker
        dateOfBirth.inputAccessoryView = toolbar
        
        
        notificationTimeField.inputView = timePicker
        notificationTimeField.inputAccessoryView = timeToolbar
        
        getDataFromFirebase()
        self.setupNavigationBar()
    }
    
    func resign(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: Date())
        let currentString = dateFormatter.string(from: datePicker.date)
        if dateString == currentString {
            dateOfBirth.text = dateString
        }
        self.view.endEditing(true)
        
    }
    
    func resignTime(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: Date())
        let currentString = dateFormatter.string(from: timePicker.date)
        if dateString == currentString {
            notificationTimeField.text = dateString
        }
        self.view.endEditing(true)
    }
    
    func getDataFromFirebase() {
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(UserDetails.uid) {
                let firebase = FirebaseMethods()
                firebase.getDataFromFirebase { (userName, birthDate , time) in
                    self.addActivityViewController(self.activityView, false)
                    self.nameTextField.text = userName
                    self.dateOfBirth.text = birthDate
                    self.notificationTimeField.text = time
                }
            }
            else {
                self.addActivityViewController(self.activityView, false)
            }
        })
    }
    
    func handleDateChange(sender : UIDatePicker) {
        UserDetails.userBirthDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: UserDetails.userBirthDate)
        dateOfBirth.text = dateString
    }
    
    func handleTimeChange(sender : UIDatePicker) {
        UserDetails.notificationTime = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: UserDetails.notificationTime)
        notificationTimeField.text = dateString
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Text Field Placeholder
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        dateOfBirth.attributedPlaceholder = NSAttributedString(string: "Date Of Birth", attributes: [NSForegroundColorAttributeName : UIColor.white])
        notificationTimeField.attributedPlaceholder = NSAttributedString(string: "Notification Time", attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        //cancel button
        if UserDetails.update {
            cancelButton.isEnabled = true
            saveDetailsButton.setTitle("UPDATE DETAILS", for: .normal)
            detailsLabel.isHidden = true
        }
        else {
            cancelButton.isEnabled = false
            detailsLabel.isHidden = false
            
        }
        
        //logOut New User
        if UserDetails.logOut {
            UserDetails.logOut = false
            self.dismiss(animated: true, completion: nil)
        }
        activityView1.isHidden = true
    }
    
    
    @IBAction func saveDetailsPressed(_ sender: Any) {
        UserDetails.userName = nameTextField.text!
        savingDetailsToFirebase()
        return
    }
    
    func savingDetailsToFirebase() {
        self.activityView1.isHidden = false
        addActivityViewController(self.activityView1, true)
        let fir = FirebaseMethods()
        
        //network connection
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView1, false)
            showAlert("No Internet Connection")
        }
        else {
            if UserDetails.update {
                fir.FirebaseUpdateData({ (success) in
                    if success {
                        self.addActivityViewController(self.activityView1, false)
                        self.performSegue(withIdentifier: "userCreationSegue", sender: self)
                    }
                    else {
                        self.addActivityViewController(self.activityView1, false)
                        self.showAlert("Could not update data")
                    }
                })
            }
            else {
                fir.FirebaseWriteData({ (success) in
                    if success {
                        self.addActivityViewController(self.activityView1, false)
                        self.performSegue(withIdentifier: "userCreationSegue", sender: self)
                    }
                    else {
                        self.addActivityViewController(self.activityView1, false)
                        self.showAlert("Could not update data")
                    }
                })
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        UserDetails.update = false
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UserDetailsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
