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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton : UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var logInButton : UIButton!
    @IBOutlet weak var forgotPasswordButton : UIButton!
    @IBOutlet weak var signUpButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        UserDefaults.standard.set(1, forKey: "initialPage")
        setupButtons()
        setupGoogleSignIn()
        
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
    
    
    func setupButtons() {
        facebookLoginButton.clipsToBounds = true
        facebookLoginButton.layer.cornerRadius = 25
        
        googleLoginButton.clipsToBounds = true
        googleLoginButton.layer.cornerRadius = 25
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        self.activityView.isHidden = false
        
        //resign text fields
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
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
                    UserDetails.uid = (user?.uid)!
                    self.logUser((user?.email)!)
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                else {
                    self.loginError(error!)
                }
            })
        }
    }
    
    func interactionEnabled(_ bool : Bool){
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        logInButton.isEnabled = bool
        forgotPasswordButton.isEnabled = bool
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
                self.loginError(error!)
            } else {
                if (result?.isCancelled)! {
                    self.addActivityViewController(self.activityView, false)
                    self.interactionEnabled(true)
                } else {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        self.addActivityViewController(self.activityView, true)
                        if error != nil {
                            self.loginError(error!)
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
    
    func loginError(_ error : Error) {
        self.addActivityViewController(self.activityView, false)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
//        self.showAlert(errorMessages.loginError)
        self.showAlert(error.localizedDescription)
        self.interactionEnabled(true)
    }
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController : GIDSignInDelegate , GIDSignInUIDelegate  {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.interactionEnabled(false)
        self.addActivityViewController(self.activityView, true)
        if  error != nil {
            loginError(error!)
            self.interactionEnabled(true)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
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
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
}
