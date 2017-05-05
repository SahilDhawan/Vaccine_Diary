//
//  SignUpViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 05/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var appTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        backgroundImage.alpha = 0.8
        appTitle.font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 35)
        
    }
    
    @IBAction func segmentControlPressed(_ sender: Any)
    {
        let value = self.segmentControl.titleForSegment(at: self.segmentControl.selectedSegmentIndex)
        if self.segmentControl.selectedSegmentIndex == 1
        {
            self.signUpButton.setTitle(value, for: .normal)
            self.confirmPasswordTextField.isHidden = true
        }
        else
        {
            self.signUpButton.setTitle(value, for: .normal)
            self.confirmPasswordTextField.isHidden = false
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
