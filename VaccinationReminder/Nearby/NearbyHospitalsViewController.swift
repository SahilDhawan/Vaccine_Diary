//
//  NearbyHospitalsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyHospitalsViewController: UIViewController, MKMapViewDelegate {
    
    var hospitalsArray : [PlacesObject] = []
    var hospitalCoordinates : [CLLocationCoordinate2D] = []
    var hospitalDetailArray : [[String : String]] = []
    var currentHospital = [String:String]()
    var currentHospitalCoordiate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    let locationManager = CLLocationManager()
    var updateLocation = true
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var userLocButton : UIButton!
    
    let tableViewCellIdentifier = "hospitalCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView
        mapView.delegate = self
        
        //tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
//        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        self.setupNavigationBar()
        
        let nearbyNib = UINib(nibName: "NearbyViewTableViewCell", bundle: nil)
        tableView.register(nearbyNib, forCellReuseIdentifier: tableViewCellIdentifier)
        
        self.userLocButton.isHidden = true
        userLocButton.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
    }
    
    @IBAction func refreshButtonPressed(){
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        googleApiFetch()
    }
    
    func centerMap(){
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
    func googleApiFetch() {
        //google place api fetch
        let googlePlaces  = GooglePlaces()
        googlePlaces.fetchData(googlePlaces.createHospitalUrl()) { (result, error) in
            
            if error == nil {
                self.hospitalsArray = result!
                for hospital in result! {
                    let geometryArray = hospital.geometry!
                    let locationArray = geometryArray.location
                    self.hospitalCoordinates.append(CLLocationCoordinate2D(latitude: (locationArray?.lat)!, longitude: (locationArray?.lng)!))
                    
                    //hospital detail array
                    var hospitalDetail = [String:String]()
                    hospitalDetail["Name"] = hospital.name!
                    hospitalDetail["Address"] = hospital.vicinity!
                    if let rating = hospital.rating {
                        hospitalDetail["Rating"] = "\(rating)"
                    } else {
                        hospitalDetail["Rating"] = "Information Not Available"
                    }
                    if let openingHour = hospital.openingHours?.openNow{
                        if openingHour == true {
                            hospitalDetail["Open Now"] = "Yes"
                        } else {
                            hospitalDetail["Open Now"] = "No"
                        }
                    }else {
                        hospitalDetail["Open Now"] = "Information Not Available"
                    }
                    self.hospitalDetailArray.append(hospitalDetail)
                }
//                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.createMapPins()
            }
            else {
                self.showAlert((error?.localizedDescription)!)
                print(error.debugDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        
        //activityView
        addActivityViewController(activityView, true)
        //network connection
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        } else {
            self.addActivityViewController(self.activityView, false)
            tableView.reloadData()
        }
    }
    
    func createMapPins() {
        for i in 0..<hospitalsArray.count {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = hospitalCoordinates[i]
            mapPin.title = hospitalsArray[i].name!
            self.mapView.addAnnotation(mapPin)
        }
        self.userLocButton.isHidden = false
    }
    
    func createUserLocation() {
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        self.mapView.setRegion(mapRegion, animated: true)
        googleApiFetch()
        addActivityViewController(self.activityView, false)
        self.updateLocation = false
        self.locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailTableViewController
        destination.currentPlace = currentHospital
        destination.fromHospital = true
        destination.currentPlaceLocation = currentHospitalCoordiate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "hospitalPin")
        if annotation.title! != "My Location" {
            annotationView.image = UIImage(named : "hospitalPin")
            return annotationView

        } else {
            return nil
        }
    }
}

extension NearbyHospitalsViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier) as! NearbyViewTableViewCell
        cell.ratingLabel.text = hospitalsArray[indexPath.item].vicinity
        cell.titleLabel.text = hospitalsArray[indexPath.item].name
        cell.countLabel.text = "\(indexPath.item + 1)."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalsArray.count
    }
}

extension NearbyHospitalsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentHospital = hospitalDetailArray[indexPath.item]
        currentHospitalCoordiate  = hospitalCoordinates[indexPath.item]
        self.performSegue(withIdentifier: "hospitalDetailSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
        addActivityViewController(self.activityView, false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension NearbyHospitalsViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        if status == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
    }
}



