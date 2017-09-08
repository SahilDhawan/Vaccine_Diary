//
//  OpeningHours.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class OpeningHours : Mappable {
    var openNow : Bool?
    var weekdayText : [String]?
    
    func mapping(map: Map) {
        openNow <- map["open_now"]
        weekdayText <- map["weekday_text"]
    }
    
    required init?(map: Map) {
        
    }
}
