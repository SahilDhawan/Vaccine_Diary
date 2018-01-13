//
//  UserProfileTableViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 10/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import FBSDKLoginKit

class UserProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var userBirthLabel : UILabel!
    @IBOutlet weak var notificationLabel : UILabel!
    @IBOutlet weak var nextVaccinationLabel : UILabel!
    @IBOutlet weak var completedVaccinesLabel : UILabel!
    @IBOutlet weak var dueVaccinesLabel : UILabel!
    
    @IBOutlet weak var activityView : UIActivityIndicatorView!

    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    let segueArray = ["contactSegue" , "creditsSegue"]
    let tableNameArray = ["Contact Developer" , "Credits" , "Refer to a Friend"]
    let tableImageArray = ["contact","credits","refer"]
    
    
    fileprivate func setupUserImage() {
        //getting user image
        if let imageData = defaults.object(forKey: "userImage") as? NSData {
            let image = UIImage(data: imageData as Data)
            userImage.image = image
        } else {
            if UserDetails.userGender == "Boy" {
                self.userImage.image = UIImage(named: "boy")
            } else {
                self.userImage.image = UIImage(named: "girl")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        if Reachability().isConnectedToNetwork() == false {
            showAlert("No Internet Connection")
        }
        
        //gradient
        let gradient = CAGradientLayer()
        gradient.colors = [colors.darkBlueColor.cgColor , loginColors.pinkColor.cgColor]
        gradient.frame = self.profileView.bounds
        self.profileView.layer.insertSublayer(gradient, at: 0)
        
        //tableView
        tableView.tableFooterView = UIView()
        
        setupUserImage()
        
        userImage.clipsToBounds = true
        userImage.layer.borderColor = colors.whiteColor.cgColor
        userImage.layer.borderWidth = 1.0
        
        let height = userImage.frame.height
        let width = userImage.frame.width
        if height > width {
            userImage.layer.cornerRadius = height/2
        } else {
            userImage.layer.cornerRadius = width/2
        }
        
        activityView.activityIndicatorViewStyle = .whiteLarge
        activityView.startAnimating()
        activityView.isHidden = false
        
        self.setupNavigationBar()
        getDataFromFirebase()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        UserDetails.update = true
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserDetailNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
   
    
    func getDataFromFirebase() {
        let fir = FirebaseMethods()
        editBarButtonItem.isEnabled = false
        fir.getDataFromFirebase { (name,birthDate,time,userGender) in
            
            UserDetails.userName = name!
            self.userNameLabel.text = name!
            
            UserDetails.userGender = userGender!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            self.userBirthLabel.text = dateFormatter.string(from: UserDetails.userBirthDate)
            
            dateFormatter.dateFormat = "h:mm a"
            UserDetails.notificationTime = dateFormatter.date(from: time!)!
            self.notificationLabel.text = dateFormatter.string(from: UserDetails.notificationTime)
            
            self.editBarButtonItem.isEnabled = true
            
            self.nextVaccinationLabel.text = UserDetails.nextVaccination
            self.completedVaccinesLabel.text = "\(UserDetails.completedVaccines)"
            
            let dueVaccines = UserDetails.vaccinationList.count - UserDetails.completedVaccines
            self.dueVaccinesLabel.text = "\(dueVaccines)"
            
            self.setupUserImage()
            
            self.activityView.stopAnimating()
            self.activityView.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
}




