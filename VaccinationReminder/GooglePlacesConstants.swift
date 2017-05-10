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
    static let urlPath = "place/search/json"
    
    struct queryKeys
    {
        static let apiKey = "key"
        static let location = "location"
        static let radius = "radius"
        static let types = "types"
        static let sensor = "sensor"
    }
    struct queryValues
    {
        static let apiKey = "AIzaSyCLp_xJ7NMdVpLo8qRYnzm5mmQSIz5oWkY"
        static let location = "\(UserDetails.locationCoordinate.latitude), \(UserDetails.locationCoordinate.longitude)"
        static let radius = "500"
        static let sensor = "true"
        static let hospitalType = "Hospital"
    }
}
