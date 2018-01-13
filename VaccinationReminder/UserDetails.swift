//
//  UserDetails.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import CoreLocation

let gregorian = Calendar(identifier: .gregorian)

struct UserDetails {
    static var userImage = UIImage(named:"userIcon")
    static var userName  : String = ""
    static var userBirthDate : Date = Date()
    static var notificationTime : Date = Date()
    static var userGender : String = "Boy"
    static var locationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static var uid : String = ""
    static var update : Bool = false
    static var vaccinationList : [Vaccine] = []
    static var logOut : Bool = false
    static var nextVaccination : String = ""
    static var completedVaccines : Int = 0
    
    struct VaccinationDates {
        static var sixWeeksDate = Date()
        static var tenWeeksDate = Date()
        static var fourteenWeeksDate = Date()
        static var sixMonthsDate = Date()
        static var nineMonthsDate = Date()
        static var oneYearDate = Date()
        static var fifteenMonthsDate = Date()
        static var eighteenMonthsDate = Date()
        static var twoYearDate = Date()
        static var sixYearDate = Date()
        static var twelveYearDate = Date()
    }
}
