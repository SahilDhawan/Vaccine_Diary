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

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Updating Label Values
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").child(UserDetails.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let value = snapshot.value as? NSDictionary
            let userName = value?["username"] as? String
            let birthString = value?["birthDate"] as? String
            self.nameLabel.text = userName!
            self.birthDateLabel.text = birthString!
            UserDetails.userName = userName!
            UserDetails.userBirthDate = dateFormatter.date(from:birthString!)!
        })
        
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
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any)
    {
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
