//
//  LoginViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 05/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import GoogleSignIn

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton : UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var logInButton : UIButton!
    @IBOutlet weak var forgotPasswordButton : UIButton!
    @IBOutlet weak var signUpButton : UIButton!
    
    //MARK: View related functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        UserDefaults.standard.set(1, forKey: "initialPage")
        setupButtons()
        setupGoogleSignIn()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.interactionEnabled(true)
        emailTextField.text = ""
        passwordTextField.text = ""
        
        activityView.isHidden = true
        super.viewWillAppear(animated)
        
        //Placeholder color change
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        UserDetails.logOut = false
        
        addActivityViewController(self.activityView, true)
        
        if Auth.auth().currentUser != nil {
            self.interactionEnabled(false)
            UserDetails.uid = (Auth.auth().currentUser?.uid)!
            let ref = Database.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(UserDetails.uid) {
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                else {
                    self.performSegue(withIdentifier: "facebookLogin", sender: self)
                }
                self.addActivityViewController(self.activityView, false)
            })
        }
        else {
            interactionEnabled(true)
            self.addActivityViewController(self.activityView, false)
        }
    }
    
    //resigning text fields and setting their placeholders
    func viewTapped(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
    }
    
    // setup social media butons
    func setupButtons() {
        facebookLoginButton.clipsToBounds = true
        facebookLoginButton.layer.cornerRadius = 25
        
        googleLoginButton.clipsToBounds = true
        googleLoginButton.layer.cornerRadius = 25
    }
    
    // perform login
    @IBAction func logInPressed(_ sender: Any) {
        self.activityView.isHidden = false
        
        //resign text fields
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        // check for text fields
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlert("Email or Password Field cannot be empty!")
            self.addActivityViewController(self.activityView, false)
        } else {
            addActivityViewController(self.activityView, true)
            let email = emailTextField.text!
            let password = passwordTextField.text!
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                self.addActivityViewController(self.activityView, false)
                if error == nil {
                    // perform login segue if there is no error
                    UserDetails.uid = (user?.uid)!
                    self.logUser((user?.email)!)
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                else {
                    // else show the error to the user
                    self.loginError(error!)
                }
            })
        }
    }
    
    //enabling or desabling the interaction of the user with buttons and text fields during login process
    func interactionEnabled(_ bool : Bool){
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        logInButton.isEnabled = bool
        forgotPasswordButton.isEnabled = bool
        facebookLoginButton.isEnabled = bool
        googleLoginButton.isEnabled = bool
        signUpButton.isEnabled = bool
    }
    
    // registering the email id of the user with crashlytics
    func logUser(_ email : String){
        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    // setting up the delegates for google sign in
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // calling the sign in function for the custom google sign in button
    @IBAction func googleLoginPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // calling facebook login when button is pressed
    @IBAction func facebookLoginPressed() {
        let facebookManager = FBSDKLoginManager()
        
        // asking perfmission for email only
        facebookManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            self.interactionEnabled(false)
            self.addActivityViewController(self.activityView, true)
            
            if error != nil {
                // show the error to the user
                self.loginError(error!)
            } else {
                if (result?.isCancelled)! {
                    // if user cancels the login process
                    self.addActivityViewController(self.activityView, false)
                    self.interactionEnabled(true)
                } else {
                    // getting the credential of the user and passing it to the firebase
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        self.addActivityViewController(self.activityView, true)
                        if error != nil {
                            // showing the error to ther user if login fails
                            self.loginError(error!)
                        }
                        else {
                            // else perform login segue
                            self.interactionEnabled(false)
                            UserDetails.uid = (user?.uid)!
                            self.performLogin(user : user!)
                        }
                    })
                }
            }
        }
    }
    
    // perform login if all conditions are met
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
    
    // show the login error to the user
    func loginError(_ error : Error) {
        
        // show an alert and clear all the text fields
        self.addActivityViewController(self.activityView, false)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.showAlert(error.localizedDescription)
        self.interactionEnabled(true)
    }
}

// MARK: Text Field Delegate
extension LoginViewController : UITextFieldDelegate{
    
    // setting up text fields and resigning responder when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
        
        return true
    }
    
    // clearing the placeholder of text fields when user starts typing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            emailTextField.placeholder = ""
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        } else {
            passwordTextField.placeholder = ""
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : colors.whiteColor])
        }
    }
}

//MARK: GoogleSignInDelegate
extension LoginViewController : GIDSignInDelegate , GIDSignInUIDelegate  {
    
    // performing google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.interactionEnabled(false)
        self.addActivityViewController(self.activityView, true)
        if  error != nil {
            // show error to the userif error occured
            loginError(error!)
            self.interactionEnabled(true)
            return
        }
        // getting credential of google user
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // signing into firebase using user credentials
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                self.loginError(error!)
                self.interactionEnabled(true)
                return
            }
            self.interactionEnabled(false)
            UserDetails.uid = (user?.uid)!
            self.performLogin(user : user!)
        }
    }
    
    // necessary sign in functions for google sign in 
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
}
