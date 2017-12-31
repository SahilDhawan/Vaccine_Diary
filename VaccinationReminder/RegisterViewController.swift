//
//  RegisterViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 31/12/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton : UIButton!
    @IBOutlet weak var googleLoginButton : UIButton!
    @IBOutlet weak var registerButton : UIButton!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var confirmPasswordTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupButtons()
    }
    
    func setupTextFields() {
        emailTextField.backgroundColor = loginColors.textFieldColor
        passwordTextField.backgroundColor = loginColors.textFieldColor
        confirmPasswordTextField.backgroundColor = loginColors.textFieldColor

        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])

    }
    
    func setupButtons() {
        facebookLoginButton.clipsToBounds = true
        facebookLoginButton.layer.cornerRadius = 25
        
        googleLoginButton.clipsToBounds = true
        googleLoginButton.layer.cornerRadius = 25
    }
    
    
    @IBAction func loginButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
