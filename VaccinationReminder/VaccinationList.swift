//
//  VaccinationList.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 07/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

struct VaccinationList
{
    struct Birth
    {
        static let BCG : String = "BCG"
        static let OPV : String = "OPV 0"
        static let Hep_B : String = "Hep-B 1"
    }
    
    struct SixWeeks
    {
        static let Dtwp : String = "DTwP-1"
        static let IPV : String = "IPV 1"
        static let Hep_B = "Hep-B 2"
        static let Hib1 = "Hib 1"
        static let RotaVirus = "Rotavirus 1"
        static let PCV = "PCV 1"
    }
    
    struct TenWeeks
    {
        static let Dtp = "DTwP 2"
        static let IPV = "IPV 2"
        static let Hib = "Hib 2"
        static let RotaVirus = "Rotavirus 2"
        static let PCV = "PCV 2"
    }
    
    struct FourteenWeeks
    {
        static let Dtwp = "DTwP 3"
        static let IPV = "IPV 3"
        static let Hib = "Hib 3"
        static let RotaVirus = "Rotavirus 3"
        static let PCV = "PCV 3"
    }
    
    struct SixMonths
    {
        static let OPV = "OPV 1"
        static let Hep_B = "Hep-B 3"
    }
    
    struct NineMonths
    {
        static let OPV = "OPV 2"
        static let MMR = "MMR-1"
    }
    
    struct OneYear
    {
        static let Typohid = "Typhoid Conjugate Vaccine"
        static let Hep_A = "Hep-A 1"
    }
    
    struct FifteenMonths
    {
        static let MMR = "MMR 2"
        static let Varicella = "Varicella 1"
        static let PCV = "PCV booster"
    }
    
    struct EighteenMonths
    {
        static let Dtwp = "DTwP B1/DTaP B1"
        static let IPV = "IPV B1"
        static let B1 = "B1"
    }
    
    struct TwoYears
    {
        static let Typphoid = "Booster of Typhoid"
        static let Conjugate = "Conjugate Vaccine"
    }
    
    struct SixYears
    {
        static let Dtwp = "DTwP B2/DTaP B2"
        static let OPV = "OPV 3"
        static let Varicella = "Varicella 2"
        static let MMR = "MMR 3"
    }
    
    struct TwelveYears
    {
        static let Tdap = "Tdap/Td"
        static let HPV = "HPV"
    }
}
