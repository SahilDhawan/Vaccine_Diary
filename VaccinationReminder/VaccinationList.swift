//
//  VaccinationList.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 07/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

class VaccinationList : NSObject
{
    var VaccinationSchedule : [Vaccine] = []
    

    func setVaccineList()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        
        let date = dateFormatter.string(from: UserDetails.userBirthDate)
        
        let sixWeeksDate = dateFormatter.string(from:UserDetails.VaccinationDates.sixWeeksDate!)
        let tenWeeksDate = dateFormatter.string(from:UserDetails.VaccinationDates.tenWeeksDate!)
        let fourteenWeeksDate = dateFormatter.string(from:UserDetails.VaccinationDates.fourteenWeeksDate!)
        let sixMonthsDate = dateFormatter.string(from:UserDetails.VaccinationDates.sixMonthsDate!)
        let nineMonthsDate = dateFormatter.string(from:UserDetails.VaccinationDates.nineMonthsDate!)
        let oneYearDate = dateFormatter.string(from:UserDetails.VaccinationDates.oneYearDate!)
        let fifteenMonthsDate = dateFormatter.string(from:UserDetails.VaccinationDates.fifteenMonthsDate!)
        let eighteenMonthsDate = dateFormatter.string(from:UserDetails.VaccinationDates.eighteenMonthsDate!)
        let twoYearDate = dateFormatter.string(from:UserDetails.VaccinationDates.twoYearDate!)
        let sixYearDate = dateFormatter.string(from:UserDetails.VaccinationDates.sixYearDate!)
        let twelveYearDate = dateFormatter.string(from:UserDetails.VaccinationDates.twelveYearDate!)

        let currentDate = Date(timeIntervalSinceNow: 0)
        let birthBool = currentDate > UserDetails.userBirthDate
        let sixWeeksBool = currentDate > UserDetails.VaccinationDates.sixWeeksDate!
        let tenWeeksBool = currentDate > UserDetails.VaccinationDates.tenWeeksDate!
        let fourteenWeeksBool = currentDate > UserDetails.VaccinationDates.fourteenWeeksDate!
        let sixMonthsBool = currentDate > UserDetails.VaccinationDates.sixMonthsDate!
        let nineMonthsBool = currentDate > UserDetails.VaccinationDates.nineMonthsDate!
        let oneYearBool = currentDate > UserDetails.VaccinationDates.oneYearDate!
        let fifteenMonthBool = currentDate > UserDetails.VaccinationDates.fifteenMonthsDate!
        let eighteenMonthBool = currentDate > UserDetails.VaccinationDates.eighteenMonthsDate!
        let twoYearBool = currentDate > UserDetails.VaccinationDates.twoYearDate!
        let sixYearBool = currentDate > UserDetails.VaccinationDates.sixYearDate!
        let twelveYearBool = currentDate > UserDetails.VaccinationDates.twelveYearDate!

        //birth
        VaccinationSchedule.append(Vaccine("BCG",date,birthBool))
        VaccinationSchedule.append(Vaccine("OPV 0",date,birthBool))
        VaccinationSchedule.append(Vaccine("Hep-B 1",date,birthBool))
        
        //SixWeeks
        VaccinationSchedule.append(Vaccine("DTwP-1",sixWeeksDate,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 1",sixWeeksDate,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Hep-B 2",sixWeeksDate,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 1",sixWeeksDate,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 1",sixWeeksDate,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 1",sixWeeksDate,sixWeeksBool))
        
        //TenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 2",tenWeeksDate,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 2",tenWeeksDate,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 2",tenWeeksDate,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 2",tenWeeksDate,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 2",tenWeeksDate,tenWeeksBool))
        
        //FourteenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 3",fourteenWeeksDate,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 3",fourteenWeeksDate,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 3",fourteenWeeksDate,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 3",fourteenWeeksDate,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 3",fourteenWeeksDate,fourteenWeeksBool))
        
        //SixMonths
        VaccinationSchedule.append(Vaccine("OPV 1",sixMonthsDate,sixMonthsBool))
        VaccinationSchedule.append(Vaccine("Hep-B 3",sixMonthsDate,sixMonthsBool))
        
        //NineMonths
        VaccinationSchedule.append(Vaccine("OPV 2",nineMonthsDate,nineMonthsBool))
        VaccinationSchedule.append(Vaccine("MMR-1",nineMonthsDate,nineMonthsBool))
        
        //OneYear
        VaccinationSchedule.append(Vaccine("Typhoid Conjugate",oneYearDate,oneYearBool))
        VaccinationSchedule.append(Vaccine("Hep-A 1",oneYearDate,oneYearBool))
        
        //FifteenMonths
        VaccinationSchedule.append(Vaccine("MMR 2",fifteenMonthsDate,fifteenMonthBool))
        VaccinationSchedule.append(Vaccine("Varicella 1",fifteenMonthsDate,fifteenMonthBool))
        VaccinationSchedule.append(Vaccine("PCV booster",fifteenMonthsDate,fifteenMonthBool))
        
        //EighteenMonths
        VaccinationSchedule.append(Vaccine("DTwP B1/DTaP B1",eighteenMonthsDate,eighteenMonthBool))
        VaccinationSchedule.append(Vaccine("IPV B1",eighteenMonthsDate,eighteenMonthBool))
        VaccinationSchedule.append(Vaccine("B1",eighteenMonthsDate,eighteenMonthBool))
        
        //TwoYears
        VaccinationSchedule.append(Vaccine("Booster of Typhoid",twoYearDate,twoYearBool))
        VaccinationSchedule.append(Vaccine("Conjugate Vaccine",twoYearDate,twoYearBool))
        
        //SixYears
        VaccinationSchedule.append(Vaccine("DTwP B2/DTaP B2",sixYearDate,sixYearBool))
        VaccinationSchedule.append(Vaccine("OPV 3",sixYearDate,sixYearBool))
        VaccinationSchedule.append(Vaccine("Varicella 2",sixYearDate,sixYearBool))
        VaccinationSchedule.append(Vaccine("MMR 3",sixYearDate,sixYearBool))
        
        //TwelveYears
        VaccinationSchedule.append(Vaccine("Tdap/Td",twelveYearDate,twelveYearBool))
        VaccinationSchedule.append(Vaccine("HPV",twelveYearDate,twelveYearBool))
    }
    
    
    func getTableSize() ->Int
    {
        let tableSize = VaccinationSchedule.count
        return tableSize
    }
    
    func getVaccineDetails() -> [Vaccine]
    {
        return VaccinationSchedule
    }
}
