//
//  UserProfileViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 10/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Updating Label Values
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").child(UserDetails.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameLabel.text = value?["username"] as? String
            self.streetLabel.text = value?["locality"] as? String
            self.stateLabel.text = value?["state"] as? String
            self.birthDateLabel.text = value?["birthDate"] as? String
        })
        
        //navigationBar
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do
        {
            try firebaseAuth?.signOut()
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(controller, animated: true, completion: nil)
        }
            
        catch
        {
            showAlert("Problem Loggin Out. Try again!")
        }
    }
    
    @IBAction func UpdateButtonPressed(_ sender: Any) {
        UserDetails.update = true
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        self.present(controller, animated: true, completion: nil)
    }
}
