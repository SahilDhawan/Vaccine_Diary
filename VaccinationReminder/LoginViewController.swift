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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var facebookSignInButton: FBSDKLoginButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var activityView1: UIActivityIndicatorView!
    @IBOutlet weak var logInButton : UIButton!
    @IBOutlet weak var forgotPasswordButton : UIButton!
    @IBOutlet weak var signUpButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        facebookSignInButton.readPermissions = ["email"]
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
        
        facebookSignInButton.delegate = self
        UserDetails.logOut = false
        
        addActivityViewController(self.activityView1, true)
        
        if FIRAuth.auth()?.currentUser != nil {
            self.interactionEnabled(false)
            UserDetails.uid = (FIRAuth.auth()?.currentUser?.uid)!
            let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(UserDetails.uid) {
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                else {
                    self.performSegue(withIdentifier: "facebookLogin", sender: self)
                }
                self.addActivityViewController(self.activityView1, false)
            })
        }
        else {
            interactionEnabled(true)
            self.addActivityViewController(self.activityView1, false)
        }
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        self.activityView.isHidden = false
        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlert("Email or Password Field cannot be empty!")
            self.addActivityViewController(self.activityView, false)
        } else {
            addActivityViewController(self.activityView, true)
            let email = emailTextField.text!
            let password = passwordTextField.text!
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                self.addActivityViewController(self.activityView, false)
                if error == nil {
                    UserDetails.uid = (user?.uid)!
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                else {
                    self.showAlert((error?.localizedDescription)!)
                }
            })
        }
    }
    
    func interactionEnabled(_ bool : Bool){
        emailTextField.isUserInteractionEnabled = bool
        passwordTextField.isUserInteractionEnabled = bool
        logInButton.isUserInteractionEnabled = bool
        forgotPasswordButton.isUserInteractionEnabled = bool
        facebookSignInButton.isUserInteractionEnabled = bool
        signUpButton.isUserInteractionEnabled = bool
    }
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        self.activityView.isHidden = false
        self.interactionEnabled(false)
        self.addActivityViewController(self.activityView, true)
        if error != nil {
            self.showAlert(error.localizedDescription)
            self.addActivityViewController(self.activityView, false)
        }
        else {
            if result.isCancelled {
                self.addActivityViewController(self.activityView, false)
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        self.showAlert((error?.localizedDescription)!)
                        self.showAlert("\(String(describing: error))")
                    }
                    else {
                        UserDetails.uid = (user?.uid)!
                        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
                        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild(UserDetails.uid) {
                                self.addActivityViewController(self.activityView, false)
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                            } else {
                                self.addActivityViewController(self.activityView, false)
                                self.performSegue(withIdentifier: "facebookLogin", sender: self)
                            }
                        })
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
