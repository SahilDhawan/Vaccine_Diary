//
//  Result.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class Result : Mappable {
    
    var htmlAttributions : [String]?
    var nextPageToken : String?
    var results : [PlacesObject]?
    var status : String?
    
    func mapping(map: Map) {
        htmlAttributions <- map["html_attributions"]
        nextPageToken <- map["next_page_token"]
        results <- map["results"]
        status <- map["status"]
    }
    
    required init?(map: Map) {
        
    }
}
