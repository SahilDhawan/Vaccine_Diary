//
//  PasswordResetViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 13/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField : UITextField!
    
    //MARK: View related functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        emailTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    // func setup Text Field Placeholders
    func setupTextFields() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
    }
    
    // reset password of user
    @IBAction func resetPasswordButtonPressed() {
        // check if text field is not empty
        if emailTextField.text != "" {
            let email = emailTextField.text
            // calling the firebase password reset function of firebase methods struct
            FirebaseMethods().FirebasePasswordReset(email!, completionHandler: { (bool, error) in
                // if success
                if bool {
                    DispatchQueue.main.async {
                        // show alert of reset password to user
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
                    // show alert of error to user
                    DispatchQueue.main.async {
                        self.showAlert((error?.localizedDescription)!)
                    }
                }
            })
        } else {
            self.showAlert("Email Address Field cannot be empty!")
        }
    }
    
    //resigning text fields and setting their placeholders
    func viewTapped(){
        emailTextField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        
    }
    
    // dismiss view controller when login button is pressed
    @IBAction func logInButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Text Field Delegate
extension PasswordResetViewController : UITextFieldDelegate {
    
    // setup placeholders of text field and resigning responder when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        
        return true
    }
    
    // clearing the placeholder of text field when user starts typing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
}
