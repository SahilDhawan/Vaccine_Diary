//
//  UserProfileViewController.swift
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

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var profileView : UIImageView!
    
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addActivityViewController(activityView, true)
        
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        nameLabel.text = ""
        birthDateLabel.text = ""
        notificationTimeLabel.text = ""
        
        mapView.showsUserLocation = true
        mapView.alpha = 0.5
        getDataFromFirebase()
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        }
        
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
        
        self.setupNavigationBar()
        setupProfile()
    }
    
    func setupProfile(){
        let height = UIScreen.main.bounds.height
        profileView.translatesAutoresizingMaskIntoConstraints = true
        profileView.frame.origin = CGPoint(x: 0, y: 0)
        if height < 600 {
            //for iphone 5s and SE
            profileView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height - 250)
        } else {
            //for other iphones
            profileView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height - 350)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        UserDetails.update = true
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserDetailNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getDataFromFirebase() {
        let fir = FirebaseMethods()
        editButtonItem.isEnabled = false
        fir.getDataFromFirebase { (name,birthDate,time,userGender) in
            self.nameLabel.text = name!.uppercased()
            self.birthDateLabel.text = birthDate!
            self.notificationTimeLabel.text = time!
            UserDetails.userName = name!
            UserDetails.userGender = userGender!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            dateFormatter.dateFormat = "h:mm a"
            UserDetails.notificationTime = dateFormatter.date(from: time!)!
            self.addActivityViewController(self.activityView, false)
            self.editButtonItem.isEnabled = true
        }
    }
    
   
}

extension UserProfileViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let coordinate = location?.coordinate
        UserDetails.locationCoordinate = coordinate!
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert("cannot fetch Current Location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

