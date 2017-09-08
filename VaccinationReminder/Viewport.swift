//
//  Viewport.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class Viewport : Mappable {
    
    var northeast : Location?
    var southwest : Location?
    
    func mapping(map: Map) {
        northeast <- map["northeast"]
        southwest <- map["southwest"]
    }
    
    required init?(map: Map) {
        
    }
}

