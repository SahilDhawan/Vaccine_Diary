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
                        let msg = "A password reset email has been sent to your email address " + self.emailTextField.text! + " . This email should reflect in your mailbox within 24 hours."
                        let alertController = UIAlertController(title: "Vaccine Diary", message:msg , preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (acion) in
                            self.emailTextField.text = ""
                            self.emailTextField.resignFirstResponder()
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
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
