//
//  Vaccine.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class Vaccine: NSObject {
    
    var vaccineName : String
    var vaccineDate : Date
    var vaccineCompletion : Bool
    public init(_ name : String , _ date : Date , _ completed : Bool) {
        
        vaccineName = name
        vaccineDate = date
        vaccineCompletion = completed
    }
}
