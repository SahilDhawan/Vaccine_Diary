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
    
    
    
    let locationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addActivityViewController(activityView, true)
        //Updating Label Values
        
        //navigationBar
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        let fir = FirebaseMethods()
        fir.getDataFromFirebase { (name, birthDate) in
            self.nameLabel.text = name!
            self.birthDateLabel.text = birthDate!
            UserDetails.userName = name!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            self.addActivityViewController(self.activityView, false)
            
        }
        
        if Reachability().isConnectedToNetwork() == false
        {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        }

        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        UserDetails.update = true
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserDetailNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any)
    {
        addActivityViewController(activityView, true)
        let firebaseAuth = FIRAuth.auth()
        do
        {
            UserDetails.logOut = true
            try firebaseAuth?.signOut()
            FBSDKLoginManager().logOut()
            self.addActivityViewController(self.activityView, false)
            self.dismiss(animated: true, completion: nil)
        }
        catch
        {
            self.addActivityViewController(self.activityView, false)
            showAlert("Problem Logging Out. Try again!")
        }
    }
    
}

extension UserProfileViewController : CLLocationManagerDelegate
{
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
        if status == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
    }
}
