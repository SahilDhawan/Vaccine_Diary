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
    
    var hospitalsArray : [String] = []
    var hospitalCoordinates : [CLLocationCoordinate2D] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView
        mapView.delegate = self
        self.mapView.isUserInteractionEnabled = false
        
        
        tableView.dataSource = self
        
        let googlePlaces  = GooglePlaces()
        googlePlaces.fetchData(googlePlaces.createHospitalUrl()) { (data, error) in
            
            if error == nil
            {
                do
                {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let resultsArray = dict["results"] as! [[String:AnyObject]]
                    for result in resultsArray
                    {
                        self.hospitalsArray.append(result["name"] as! String)
                        let geometryArray = result["geometry"] as! [String:AnyObject]
                        let locationArray = geometryArray["location"] as! [String:AnyObject]
                        self.hospitalCoordinates.append(CLLocationCoordinate2D(latitude: locationArray["lat"] as! CLLocationDegrees, longitude: locationArray["lng"] as! CLLocationDegrees))
                    }
                    print(self.hospitalCoordinates)
                    print(self.hospitalsArray)
                    self.tableView.reloadData()
                    self.createMapPins()
                }
                catch
                {
                    self.showAlert("Unwanted error has occurred")
                }
            }
            else
            {
                self.showAlert((error?.localizedDescription)!)
                print(error.debugDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationBar
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)

    }
    
    func createMapPins()
    {
        let mapRegion = MKCoordinateRegion(center: UserDetails.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(mapRegion, animated: true)
        
        for i in 0..<hospitalsArray.count
        {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = hospitalCoordinates[i]
            mapPin.title = hospitalsArray[i]
            self.mapView.addAnnotation(mapPin)
        }
    }
}

extension NearbyHospitalsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hospitalsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyHospitalCell")
        cell?.textLabel?.text = hospitalsArray[indexPath.item]
        return cell!
    }
}
