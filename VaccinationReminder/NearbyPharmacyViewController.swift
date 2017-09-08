//
//  NearbyPharmacyViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyPharmacyViewController: UIViewController , MKMapViewDelegate {
    
    var pharmacyArray : [String] = []
    var pharmacyCoordinates : [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var updateLocation = true
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    func googleApiFetch() {
        let googlePlaces = GooglePlaces()
        googlePlaces.fetchData(googlePlaces.createPharmacyUrl()) { (data, error) in
            
            if error == nil {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let resultsArray = dict["results"] as! [[String:AnyObject]]
                    for result in resultsArray {
                        self.pharmacyArray.append(result["name"] as! String)
                        let geometryArray = result["geometry"] as! [String:AnyObject]
                        let locationArray = geometryArray["location"] as! [String:AnyObject]
                        self.pharmacyCoordinates.append(CLLocationCoordinate2D(latitude: locationArray["lat"] as! CLLocationDegrees, longitude: locationArray["lng"] as! CLLocationDegrees))
                    }
                    DispatchQueue.main.async {
                        self.addActivityViewController(self.activityView, false)
                        self.tableView.reloadData()
                        self.createMapPins()
                    }
                }
                catch {
                    self.showAlert("Unwanted error has occurred")
                }
            }
            else {
                self.showAlert((error?.localizedDescription)!)
                print(error.debugDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityViewController(self.activityView, true)
        
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        //network connection
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.setupNavigationBar()
    }
}

extension NearbyPharmacyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pharmacyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyDoctorCell")
        cell?.textLabel?.text = "\(indexPath.item + 1). " + pharmacyArray[indexPath.item]
        return cell!
    }
    
    func createMapPins() {
        for i in 0..<pharmacyArray.count {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = pharmacyCoordinates[i]
            mapPin.title = pharmacyArray[i]
            self.mapView.addAnnotation(mapPin)
        }
    }
    
    func createUserLocation() {
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(mapRegion, animated: true)
        googleApiFetch()
        addActivityViewController(self.activityView, false)
        self.updateLocation = false
    }
}

extension NearbyPharmacyViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if self.updateLocation == true {
            let location = locations.last
            let coordinate = location?.coordinate
            UserDetails.locationCoordinate = coordinate!
            createUserLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert("cannot fetch current location")
        addActivityViewController(self.activityView, false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

