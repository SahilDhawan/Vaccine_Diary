//
//  detailTableViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 16/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailTableViewController : UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLocButton : UIButton!
    @IBOutlet weak var directionsButton : UIButton!

    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var openNow : UILabel!
    
    var updateLocation = true
    var fromHospital : Bool = false
    var currentPlace = [String:String]()
    var nameLabelHeight : CGFloat = 0.0
    var addressLabelHeight : CGFloat = 0.0
    let locationManager = CLLocationManager()
    var currentPlaceLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var mapHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.setupNavigationBar()
        setupTableView()
        setupLocationManager()
        createMapPin()
        createUserLocation()
    }
    
    func setupView(){
        if fromHospital {
            self.navigationItem.title = "Hospital Detail"
        } else {
            self.navigationItem.title = "Pharmacy Detail"
        }
        self.userLocButton.isHidden = true
        self.directionsButton.isHidden = true
        
        if fromHospital {
           setupButtonColor(color: colors.orangeColor)
        } else {
           setupButtonColor(color: colors.darkBlueColor)
        }
        
        userLocButton.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
        directionsButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
    }
    
    //setup text label colors
    func setupButtonColor(color : UIColor) {
        name.textColor = color
        address.textColor = color
        rating.textColor = color
        openNow.textColor = color
    }
    
    func directionButtonTapped(){
        
        let latitude = currentPlaceLocation.latitude
        let longitude = currentPlaceLocation.longitude
        
        if UIApplication.shared.canOpenURL(URL(string : "comgooglemaps://")!) {
            let appUrlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&zoom=14"
            UIApplication.shared.open(URL(string : appUrlString)!, options: [:], completionHandler: nil)
        }
    }
        
    func centerMap(){
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.010, longitudeDelta: 0.010))
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
    func setupTableView() {
        nameLabel.text = currentPlace["Name"]
        nameLabel.sizeToFit()
        
        addressLabel.text = currentPlace["Address"]
        addressLabel.sizeToFit()
        
        ratingLabel.text = currentPlace["Rating"]
        openNowLabel.text = currentPlace["Open Now"]
        tableView.allowsSelection = false

        tableView.tableFooterView = UIView()
        tableView.reloadData()
        setupMapView()
    }
    
    func setupMapView() {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        nameLabelHeight = nameLabel.frame.height + 15.0
        addressLabelHeight = addressLabel.frame.height + 15.0
        if nameLabelHeight < 45 {
            nameLabelHeight  = 45.0
        }
        if addressLabelHeight < 45 {
            addressLabelHeight = 45.0
        }
        mapHeight  = self.view.frame.height - navigationBarHeight! - tabBarHeight! - statusBarHeight - 90 - nameLabelHeight  - addressLabelHeight
        mapView.showsUserLocation = true
        mapView.delegate = self
        tableView.tableHeaderView?.frame.size.height = mapHeight
    }
    
    
    func setupLocationManager(){
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func createMapPin() {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = currentPlaceLocation
            mapPin.title = currentPlace["Name"]
            self.mapView.addAnnotation(mapPin)
        self.userLocButton.isHidden = false
        self.directionsButton.isHidden = false

    }
    
    func createUserLocation() {
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(mapRegion, animated: true)
        self.updateLocation = false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat
        if indexPath == IndexPath(row: 0, section: 0){
            height = nameLabel.frame.height + 15.0
            if height > 45 {
                return height
            } else {
                return 45.0
            }
        } else if indexPath == IndexPath(row: 1, section: 0){

            height = addressLabel.frame.height + 15.0
            if height > 45 {
                return height
            } else {
                return 45.0
            }
        } else {
            return 45.0
        }
    }
}

//MARK: MKMapViewDelegate
extension DetailTableViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "hospitalPin")
        if annotation.title! != "My Location" {
            if fromHospital {
            annotationView.image = UIImage(named : "hospitalPin")
            } else {
                annotationView.image = UIImage(named : "pharmacyPin")
            }
        } else {
            annotationView.image = UIImage(named : "userPin")
            
        }
        return annotationView
    }
}

//MARK: CLLocationManagerDelegate
extension DetailTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.updateLocation == true {
            let location = locations.last
            let coordinate = location?.coordinate
            UserDetails.locationCoordinate = coordinate!
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert("cannot fetch current location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

