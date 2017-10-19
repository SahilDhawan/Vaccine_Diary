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
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
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
        
        mapView.showsUserLocation = true
        getDataFromFirebase()
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        }
        cardView.dropShadow()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 20
        
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
        userImage.backgroundColor = UIColor.clear        
        self.setupNavigationBar()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        UserDetails.update = true
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserDetailNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    func getDataFromFirebase() {
        let fir = FirebaseMethods()
        editButtonItem.isEnabled = false
        fir.getDataFromFirebase { (name,birthDate,time,userGender) in
            self.nameLabel.text = name!
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

