//
//  Location.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class Location : Mappable {
    var lat : Double?
    var lng : Double?
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
    required init?(map: Map) {
        
    }
}
