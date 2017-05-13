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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPass.delegate = self
        
        //setting up placeholder text
        emailTextField.attributedPlaceholder = NSAttributedString(string: "  Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "  Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : UIColor.white])
        confirmPass.attributedPlaceholder = NSAttributedString(string: "  Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.white])

    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
                guard let email = emailTextField.text , let password = passwordTextField.text , let confirm = confirmPass.text  else
                {
                    showAlert("Email or Password Text Fields can't be empty")
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.confirmPass.text = ""
                    return
                }
                if confirm != password
                {
                    showAlert("Passwords Don't match. Please try again!")
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.confirmPass.text = ""
                }
                else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (FIRUser, error) in
        
                        if error == nil
                        {
                            UserDetails.uid = (FIRUser?.uid)!
                            self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                        }
                        else
                        {
                            self.showAlert("Can not create a new user")
                        }
        
                    })
                }
    }
}

extension SignUpViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
