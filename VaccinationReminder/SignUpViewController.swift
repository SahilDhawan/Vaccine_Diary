//
//  SignUpViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 07/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    //MARK : Outlets
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPass: TextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPass.delegate = self
        
        //empty the text fields
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPass.text = ""
        
        //setting up placeholder text
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        confirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        
        UserDetails.logOut = false
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text , let confirm = confirmPass.text  else {
            showAlert("Email or Password Text Fields can't be empty")
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.confirmPass.text = ""
            return
        }
        if confirm != password {
            showAlert("Passwords Don't match. Please try again!")
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.confirmPass.text = ""
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (FIRUser, error) in
                
                if error == nil {
                    UserDetails.uid = (FIRUser?.uid)!
                    self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                }
                else {
                    self.showAlert("Can not create a new user")
                }
            })
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
