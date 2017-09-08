//
//  Geometry.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class Geometry : Mappable {
    var location : Location?
    var viewport : Viewport?
    
    func mapping(map: Map) {
        location <- map["location"]
    }
    
    required init?(map: Map) {
        
    }
}
