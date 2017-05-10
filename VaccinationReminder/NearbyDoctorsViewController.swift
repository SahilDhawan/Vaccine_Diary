//
//  NearbyDoctorsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class NearbyDoctorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert("\(UserDetails.locationCoordinate)")
    }
}
