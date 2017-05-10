//
//  UserDetails.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

let gregorian = Calendar(identifier: .gregorian)

struct UserDetails
{
    static var userImage : UIImage? = nil
    static var userName : String! = ""
    static var userBirthDate : Date = Date(timeIntervalSinceNow: 0)
    static var userGender : String = ""
    static var userState : String = ""
    
    struct VaccinationDates
    {
        static let sixWeeksDate = gregorian.date(byAdding: .day, value: 42, to: UserDetails.userBirthDate)
        static let tenWeeksDate = gregorian.date(byAdding: .day, value: 70, to: UserDetails.userBirthDate)
        static let fourteenWeeksDate = gregorian.date(byAdding: .day, value: 98, to: UserDetails.userBirthDate)
        static let sixMonthsDate = gregorian.date(byAdding: .month, value: 6, to: UserDetails.userBirthDate)
        static let nineMonthsDate = gregorian.date(byAdding: .month, value: 9, to: UserDetails.userBirthDate)
        static let oneYearDate = gregorian.date(byAdding: .year, value: 1, to: UserDetails.userBirthDate)
        static let fifteenMonthsDate = gregorian.date(byAdding: .month, value: 15, to: UserDetails.userBirthDate)
        static let eighteenMonthsDate = gregorian.date(byAdding: .month, value: 18, to: UserDetails.userBirthDate)
        static let twoYearDate = gregorian.date(byAdding: .year, value: 2, to: UserDetails.userBirthDate)
        static let sixYearDate = gregorian.date(byAdding: .year, value: 6, to: UserDetails.userBirthDate)
        static let twelveYearDate = gregorian.date(byAdding: .year, value: 12, to: UserDetails.userBirthDate)
    }
}
