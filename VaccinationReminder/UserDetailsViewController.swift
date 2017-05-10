//
//  UserDetailsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 08/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import CoreLocation

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    
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
        nameTextField.attributedPlaceholder = NSAttributedString(string: "    Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        dateOfBirth.attributedPlaceholder = NSAttributedString(string: "    Date Of Birth", attributes: [NSForegroundColorAttributeName : UIColor.white])
        streetTextField.attributedPlaceholder = NSAttributedString(string: "    Street", attributes: [NSForegroundColorAttributeName : UIColor.white])
        stateTextField.attributedPlaceholder = NSAttributedString(string: "    State", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    @IBAction func saveDetailsPressed(_ sender: Any) {
        UserDetails.userName = nameTextField.text
        UserDetails.userState = stateTextField.text!
        UserDetails.userStreet = streetTextField.text!
        
        let address = "India, " + UserDetails.userState + ", " + UserDetails.userStreet
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if error == nil
            {
                self.processResponse(withPlacemarks : placemark , error)
            }
        }

        
        self.performSegue(withIdentifier: "userCreationSegue", sender: self)
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
