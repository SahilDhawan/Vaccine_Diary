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
    
    var updateLocation = true
    var fromHospital : Bool = false
    var currentPlace = [String:String]()
    var nameLabelHeight : CGFloat = 0.0
    var addressLabelHeight : CGFloat = 0.0
    let locationManager = CLLocationManager()
    var currentPlaceLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        if fromHospital {
            self.navigationItem.title = "Hospital Detail"
        } else {
            self.navigationItem.title = "Pharmacy Detail"
        }
        self.setupNavigationBar()
        setupTableView()
        setupMapView()
        setupLocationManager()
        createMapPin()
        createUserLocation()
        
    }
    
    func setupTableView() {
        nameLabel.text = currentPlace["Name"]
        nameLabel.sizeToFit()
        nameLabelHeight = nameLabel.frame.size.height
        
        addressLabel.text = currentPlace["Address"]
        addressLabel.sizeToFit()
        addressLabelHeight = nameLabel.frame.size.height
        
        ratingLabel.text = currentPlace["Rating"]
        openNowLabel.text = currentPlace["Open Now"]
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    func setupMapView() {
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        mapView.translatesAutoresizingMaskIntoConstraints = true
        let mapHeight  = self.view.frame.height - navigationBarHeight! - tabBarHeight! - statusBarHeight - nameLabelHeight - addressLabelHeight - 90.0
        mapView.showsUserLocation = true
        mapView.frame.size = CGSize(width: self.view.frame.width, height: mapHeight)
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

extension DetailTableViewController : CLLocationManagerDelegate
{
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
        if status == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
    }
}

