//
//  PasswordResetViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 13/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        emailTextField.delegate = self
    }
    
    func setupTextFields() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
    }
    
    @IBAction func resetPasswordButtonPressed() {
        if emailTextField.text != "" {
            let email = emailTextField.text
            FirebaseMethods().FirebasePasswordReset(email!, completionHandler: { (bool, error) in
                if bool {
                    DispatchQueue.main.async {
                        self.showAlert("Password reset email has been sent to " + email!)
                        self.emailTextField.text = ""
                        self.emailTextField.resignFirstResponder()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert((error?.localizedDescription)!)
                    }
                }
            })
        } else {
            self.showAlert("Email Address Field cannot be empty!")
        }
    }
    
    @IBAction func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension PasswordResetViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
