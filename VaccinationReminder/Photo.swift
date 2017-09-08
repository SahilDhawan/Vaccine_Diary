//
//  Photo.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo : Mappable {
    var height : Int?
    var htmlAttributions : [String]?
    var photoReference : String?
    var width : Int?
    
    func mapping(map: Map) {
        height <- map["height"]
        htmlAttributions <- map["html_attributions"]
        photoReference <- map["photo_reference"]
        width <- map["width"]
    }
    
    required init?(map: Map) {
        
    }
}
