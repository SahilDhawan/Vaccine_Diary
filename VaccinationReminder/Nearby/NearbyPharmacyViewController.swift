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
    
    var pharmacyArray : [PlacesObject] = []
    var pharmacyCoordinates : [CLLocationCoordinate2D] = []
    var pharmacyDetailArray : [[String : String]] = []
    var currentPharmacy = [String:String]()
    var currentPharmacyLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    let locationManager = CLLocationManager()
    var updateLocation = true
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityViewController(self.activityView, true)
        
        //locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
      
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.setupNavigationBar()
    }
    
    func googleApiFetch() {
        let googlePlaces = GooglePlaces()
        googlePlaces.fetchData(googlePlaces.createPharmacyUrl()) { (result, error) in
            
            if error == nil {
                self.pharmacyArray = result!
                for pharmacy in result! {
                    let geometryArray = pharmacy.geometry!
                    let locationArray = geometryArray.location
                    self.pharmacyCoordinates.append(CLLocationCoordinate2D(latitude: (locationArray?.lat)!, longitude: (locationArray?.lng)!))
                    
                    //pharmacy detail array
                    var pharmacyDetail = [String:String]()
                    pharmacyDetail["Name"] = pharmacy.name!
                    pharmacyDetail["Address"] = pharmacy.vicinity!
                    if let rating = pharmacy.rating {
                        pharmacyDetail["Rating"] = "\(rating)"
                    } else {
                        pharmacyDetail["Rating"] = "Information Not Available"
                    }
                    if let openingHour = pharmacy.openingHours?.openNow!{
                        if openingHour == true {
                            pharmacyDetail["Open Now"] = "Yes"
                        } else {
                            pharmacyDetail["Open Now"] = "No"
                        }
                    }else {
                        pharmacyDetail["Open Now"] = "Information Not Available"
                    }
                    self.pharmacyDetailArray.append(pharmacyDetail)
                }
                self.addActivityViewController(self.activityView, false)
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.createMapPins()
            }
            else {
                self.showAlert((error?.localizedDescription)!)
                print(error.debugDescription)
            }
        }
    }
    
    @IBAction func refreshButtonPressed(){
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        googleApiFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailTableViewController
        destination.currentPlace = currentPharmacy
        destination.fromHospital = false
        destination.currentPlaceLocation = currentPharmacyLocation
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
}

extension NearbyPharmacyViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pharmacyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyDoctorCell")
        cell?.textLabel?.text = "\(indexPath.item + 1). " + pharmacyArray[indexPath.item].name!
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func createMapPins() {
        for i in 0..<pharmacyArray.count {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = pharmacyCoordinates[i]
            mapPin.title = pharmacyArray[i].name!
            self.mapView.addAnnotation(mapPin)
        }
    }
    
    func createUserLocation() {
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        self.mapView.setRegion(mapRegion, animated: true)
        googleApiFetch()
        addActivityViewController(self.activityView, false)
        self.updateLocation = false
    }
}


extension NearbyPharmacyViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPharmacy = pharmacyDetailArray[indexPath.item]
        currentPharmacyLocation = pharmacyCoordinates[indexPath.item]
        self.performSegue(withIdentifier: "pharmacyDetailSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.mapView.frame.size.height = 0
                self.tableView.frame.origin.y = 0
                self.tableView.frame.size.height = self.view.frame.height
                
            })
        } else if (velocity.y<=0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.mapView.frame.size.height = 225
                self.tableView.frame.origin.y = 225
                self.tableView.frame.size.height = self.view.frame.height - 225
            })
        }
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

