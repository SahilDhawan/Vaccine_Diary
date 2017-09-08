//
//  PlacesObject.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/09/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import ObjectMapper

class PlacesObject : Mappable {
    
    var geometry : Geometry?
    var icon : String?
    var id : String?
    var name : String?
    var openingHours : OpeningHours?
    var photos : [Photo]?
    var placeId : String?
    var rating : Double?
    var reference : String?
    var scope : String?
    var types : [String]?
    var vicinity : String?
    
    func mapping(map: Map) {
        geometry <- map["geometry"]
        icon <- map["icon"]
        id <- map["id"]
        name <- map["name"]
        openingHours <- map ["opening_hours"]
        photos <- map["photos"]
        placeId <- map["place_id"]
        rating <- map["rating"]
        reference <- map["reference"]
        scope <- map["scope"]
        types <- map["types"]
        vicinity <- map["vicinity"]
    }
    
    required init?(map: Map) {
        
    }
}
