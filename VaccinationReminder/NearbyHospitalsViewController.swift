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

class NearbyHospitalsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                //delegates
        self.mapView.delegate = self
    }
    
    
    }



extension NearbyHospitalsViewController : MKMapViewDelegate
{
    
}
