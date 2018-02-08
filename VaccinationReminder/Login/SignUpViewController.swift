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
    
    //MARK: View related functions
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    //resigning text fields and setting their placeholders
    func viewTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        
        if confirmPasswordTextField.text == "" {
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
    }
    
    // sign up button is pressed
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        // check for empty text fields and password matching
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
                // if conditions are met then call create user method of firebase
                Auth.auth().createUser(withEmail: email, password: password, completion: { (FIRUser, error) in
                    
                    if error == nil {
                        UserDetails.uid = (FIRUser?.uid)!
                        // if error is nil then perform Sign Up segue
                        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                    }
                    else {
                        // else show the error to user
                        self.loginError(error!)
                    }
                })
            }
        }
    }
    
    // dismiss view controller when login button is pressed
    @IBAction func logInButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // enabling and disabling the interaction of the user during sign up process
    func interactionEnabled(_ bool : Bool){
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        confirmPasswordTextField.isEnabled = bool
        signUpButton.isEnabled = bool
    }
    
    // registering user's email with crashlytics
    func logUser(_ email : String){
        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    // perform login when conditions are met
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
    
    // show error to user
    func loginError(_ error : Error) {
        self.addActivityViewController(self.activityView, false)
        self.passwordTextField.text = ""
        self.emailTextField.text = ""
        self.confirmPasswordTextField.text = ""
        self.showAlert(error.localizedDescription)
        self.interactionEnabled(true)
    }
}

//MARK: Text Field Delegate
extension SignUpViewController : UITextFieldDelegate {
    
    // setting the placeholder of text fields and resigning responder when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        if confirmPasswordTextField.text == "" {
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        return true
    }
    
    //empty the placeholder of text field when user starts typing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            
            emailTextField.placeholder = ""
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        } else if textField == passwordTextField {
            
            passwordTextField.placeholder = ""
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        } else {
            
            confirmPasswordTextField.placeholder = ""
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password (Greater than 6 digits)", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
    }
}

