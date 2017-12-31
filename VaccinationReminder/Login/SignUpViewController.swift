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
    @IBOutlet weak var googleLoginButton : UIButton!
    @IBOutlet weak var facebookLoginButton : UIButton!
    
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
        setupButtons()
        activityView.isHidden = true
        setupGoogleSignIn()
    }
    
    func setupButtons() {
        facebookLoginButton.clipsToBounds = true
        facebookLoginButton.layer.cornerRadius = 20
        googleLoginButton.clipsToBounds = true
        googleLoginButton.layer.cornerRadius = 20
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
                        self.showAlert("Can not create a new user")
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
        facebookLoginButton.isEnabled = bool
        googleLoginButton.isEnabled = bool
        signUpButton.isEnabled = bool
    }
    
    func logUser(_ email : String){
        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func googleLoginPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookLoginPressed() {
        let facebookManager = FBSDKLoginManager()
        facebookManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            self.interactionEnabled(false)
            self.addActivityViewController(self.activityView, true)
            
            if error != nil {
                self.loginError()
            } else {
                if (result?.isCancelled)! {
                    self.addActivityViewController(self.activityView, false)
                    self.interactionEnabled(true)
                } else {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        self.addActivityViewController(self.activityView, true)
                        if error != nil {
                            self.loginError()
                            self.interactionEnabled(true)
                        }
                        else {
                            self.interactionEnabled(false)
                            UserDetails.uid = (user?.uid)!
                            self.performLogin(user : user!)
                        }
                    })
                }
            }
        }
    }
    
    func performLogin(user : User){
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
    
    func loginError() {
        self.addActivityViewController(self.activityView, false)
        self.showAlert(errorMessages.loginError)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController : GIDSignInDelegate , GIDSignInUIDelegate  {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.interactionEnabled(false)
        self.addActivityViewController(self.activityView, true)
        if  error != nil {
            loginError()
            self.interactionEnabled(true)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                self.loginError()
                self.interactionEnabled(true)
                return
            }
            self.interactionEnabled(false)
            UserDetails.uid = (user?.uid)!
            self.performLogin(user : user!)
        }
    }
}

