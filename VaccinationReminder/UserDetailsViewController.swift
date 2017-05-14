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
    @IBOutlet weak var stateTextField: TextField!
    @IBOutlet weak var streetTextField: TextField!
    
    let datePicker : UIDatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates
        nameTextField.delegate = self
        dateOfBirth.delegate = self
        stateTextField.delegate = self
        streetTextField.delegate = self
        
        //datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDateChange(sender:)), for: UIControlEvents.valueChanged)
        dateOfBirth.inputView = datePicker
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
        streetTextField.attributedPlaceholder = NSAttributedString(string: "Locality", attributes: [NSForegroundColorAttributeName : UIColor.white])
        stateTextField.attributedPlaceholder = NSAttributedString(string: "State", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    @IBAction func saveDetailsPressed(_ sender: Any) {
        UserDetails.userName = nameTextField.text
        UserDetails.userState = stateTextField.text!
        UserDetails.userLocality = streetTextField.text!
        
        let address = "India, " + UserDetails.userState + ", " + UserDetails.userLocality
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if error == nil
            {
                self.processResponse(withPlacemarks : placemark , error)
            }
        }
        savingDetailsToFirebase()
        self.performSegue(withIdentifier: "userCreationSegue", sender: self)
        print(address)
    }
    
    func savingDetailsToFirebase()
    {
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        saveDict["locality"] =  UserDetails.userLocality
        saveDict["state"] =  UserDetails.userState
        
        if UserDetails.update
        {
            ref.child("users").child(UserDetails.uid).updateChildValues(saveDict)
        }
        else
        {
            
            ref.child("users").child(UserDetails.uid).setValue(saveDict)
        }
    }
    

    func processResponse(withPlacemarks placemarks : [CLPlacemark]? , _ error : Error?)
    {
        if error != nil
        {
            showAlert("Not a valid location")
        }
        else
        {
            if let placemarks  = placemarks , placemarks.count>0
            {
                let location : CLLocation?
                location = (placemarks.first?.location)!
                UserDetails.locationCoordinate = (location?.coordinate)!
                print(UserDetails.locationCoordinate)
            }
            else
            {
                showAlert("Not a valid location")
            }
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
