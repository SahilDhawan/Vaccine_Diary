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
    
    let datePicker : UIDatePicker = UIDatePicker()
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        //delegates
        nameTextField.delegate = self
        dateOfBirth.delegate = self
        
        //datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDateChange(sender:)), for: UIControlEvents.valueChanged)
        
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
        
        dateOfBirth.inputView = datePicker
        dateOfBirth.inputAccessoryView = toolbar
        
        //getting DataFromFirebase
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(UserDetails.uid)
            {
                let firebase = FirebaseMethods()
                firebase.getDataFromFirebase { (userName, birthDate) in
                    self.addActivityViewController(self.activityView, false)
                    self.nameTextField.text = userName
                    self.dateOfBirth.text = birthDate
                }
            }
            else
            {
                self.addActivityViewController(self.activityView, false)

            }
        })
    }
    
    func resign(sender : UIBarButtonItem)
    {
        self.view.endEditing(true)
    }
    
    
    func handleDateChange(sender : UIDatePicker)
    {
        UserDetails.userBirthDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: UserDetails.userBirthDate)
        dateOfBirth.text = dateString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //Text Field Placeholder
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        dateOfBirth.attributedPlaceholder = NSAttributedString(string: "Date Of Birth", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    
    @IBAction func saveDetailsPressed(_ sender: Any) {
        UserDetails.userName = nameTextField.text!
        
        savingDetailsToFirebase()
        self.performSegue(withIdentifier: "userCreationSegue", sender: self)
        return
    }
    
    func savingDetailsToFirebase()
    {
        let fir = FirebaseMethods()
        if UserDetails.update
        {
            fir.FirebaseUpdateData()
        }
        else
        {
            
            fir.FirebaseWriteData()
        }
    }
    
    
}

extension UserDetailsViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
