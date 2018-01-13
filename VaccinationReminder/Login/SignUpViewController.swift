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
import Crashlytics
import Fabric
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {
    
    //MARK : Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        //empty the text fields
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        //setting up placeholder text
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        
        UserDetails.logOut = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.isHidden = true
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if  emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == ""  {
            showAlert("Email or Password Text Fields can't be empty")
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.confirmPasswordTextField.text = ""
            return
        } else {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            let confirm = confirmPasswordTextField.text!
            
            if confirm != password {
                showAlert("Passwords Don't match. Please try again!")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
            else {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (FIRUser, error) in
                    
                    if error == nil {
                        UserDetails.uid = (FIRUser?.uid)!
                        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                    }
                    else {
                        self.loginError(error!)
                    }
                })
            }
        }
    }
    
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func interactionEnabled(_ bool : Bool){
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        confirmPasswordTextField.isEnabled = bool
        signUpButton.isEnabled = bool
    }
    
    func logUser(_ email : String){
        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    func performLogin(user : User){
        self.addActivityViewController(self.activityView, true)
        let ref = Database.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(UserDetails.uid) {
                self.addActivityViewController(self.activityView, false)
                self.interactionEnabled(false)
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                self.addActivityViewController(self.activityView, false)
                self.interactionEnabled(false)
                self.performSegue(withIdentifier: "facebookLogin", sender: self)
                self.logUser((user.email)!)
            }
        })
    }
    
    func loginError(_ error : Error) {
        self.addActivityViewController(self.activityView, false)
        self.passwordTextField.text = ""
        self.emailTextField.text = ""
        self.confirmPasswordTextField.text = ""
        self.showAlert(error.localizedDescription)
        self.interactionEnabled(true)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

