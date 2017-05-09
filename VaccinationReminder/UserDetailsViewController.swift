//
//  UserDetailsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 08/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //Text Field Placeholder
        nameTextField.attributedPlaceholder = NSAttributedString(string: "    Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        dateOfBirth.attributedPlaceholder = NSAttributedString(string: "    Date Of Birth", attributes: [NSForegroundColorAttributeName : UIColor.white])
        genderTextField.attributedPlaceholder = NSAttributedString(string: "    Gender", attributes: [NSForegroundColorAttributeName : UIColor.white])
        stateTextField.attributedPlaceholder = NSAttributedString(string: "    State", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
}
