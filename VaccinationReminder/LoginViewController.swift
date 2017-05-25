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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        facebookSignInButton.readPermissions = ["email"]
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        activityView.isHidden = true
        super.viewWillAppear(animated)
        
        //Placeholder color change
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        facebookSignInButton.delegate = self
        
        
        
        //managing firebase users
        if FIRAuth.auth()?.currentUser != nil
        {
            self.addActivityViewController(self.activityView, false)
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
            UserDetails.uid = (FIRAuth.auth()?.currentUser?.uid)!
        }
    }
    
    
    @IBAction func logInPressed(_ sender: Any) {
        self.activityView.isHidden = false
        addActivityViewController(self.activityView, true)
        guard let email = emailTextField.text,let password = passwordTextField.text else
        {
            print("Email or Password can't be empty")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil
            {
                self.addActivityViewController(self.activityView, false)
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                UserDetails.uid = (user?.uid)!
            }
            else
            {
                self.showAlert((error?.localizedDescription)!)
            }
        })
        
    }
}

extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate
{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        self.activityView.isHidden = false
        self.addActivityViewController(self.activityView, true)
        if error != nil
        {
            self.showAlert(error.localizedDescription)
        }
        else
        {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil
                {
                    self.showAlert((error?.localizedDescription)!)
                }
                else
                {
                    UserDetails.uid = (user?.uid)!
                    self.addActivityViewController(self.activityView, false)
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //TODO
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        //TODO
        return true
    }
}
