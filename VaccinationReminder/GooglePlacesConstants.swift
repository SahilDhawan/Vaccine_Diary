//
//  GooglePlacesConstants.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
struct GooglePlacesConstants
{
    static let urlScheme = "https"
    static let urlHost = "maps.googleapis.com"
    static let urlPath = "/maps/api/place/nearbysearch/json"
    
    struct queryKeys
    {
        static let location = "location"
        static let radius = "radius"
        static let type = "keyword"
        static let sensor = "sensor"
        static let apiKey = "key"

    }
    
    struct queryValues
    {
        static let location = "\(UserDetails.locationCoordinate.latitude), \(UserDetails.locationCoordinate.longitude)"
        static let radius = "500"
        static let sensor = "true"
        static let hospitalType = "Hospital"
        static let pharmacyType = "pharmacy"
        static let doctorKeyboard  = "Keyboard"
        static let apiKey = "AIzaSyBJItU0E8gSaSKQOEvaaCbCcUDsmHKYJHk"
    }
}
