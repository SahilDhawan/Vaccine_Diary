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
        VaccinationSchedule.append(Vaccine("BCG",UserDetails.userBirthDate,birthBool))
        VaccinationSchedule.append(Vaccine("OPV 0",UserDetails.userBirthDate,birthBool))
        VaccinationSchedule.append(Vaccine("Hep-B 1",UserDetails.userBirthDate,birthBool))
        
        //SixWeeks
        VaccinationSchedule.append(Vaccine("DTwP-1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Hep-B 2",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool))
        
        //TenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool))
        
        //FourteenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("IPV 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("Hib 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("Rotavirus 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool))
        VaccinationSchedule.append(Vaccine("PCV 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool))
        
        //SixMonths
        VaccinationSchedule.append(Vaccine("OPV 1",UserDetails.VaccinationDates.sixMonthsDate!,sixMonthsBool))
        VaccinationSchedule.append(Vaccine("Hep-B 3",UserDetails.VaccinationDates.sixMonthsDate!,sixMonthsBool))
        
        //NineMonths
        VaccinationSchedule.append(Vaccine("OPV 2",UserDetails.VaccinationDates.nineMonthsDate!,nineMonthsBool))
        VaccinationSchedule.append(Vaccine("MMR-1",UserDetails.VaccinationDates.nineMonthsDate!,nineMonthsBool))
        
        //OneYear
        VaccinationSchedule.append(Vaccine("Typhoid Conjugate",UserDetails.VaccinationDates.oneYearDate!,oneYearBool))
        VaccinationSchedule.append(Vaccine("Hep-A 1",UserDetails.VaccinationDates.oneYearDate!,oneYearBool))
        
        //FifteenMonths
        VaccinationSchedule.append(Vaccine("MMR 2",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool))
        VaccinationSchedule.append(Vaccine("Varicella 1",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool))
        VaccinationSchedule.append(Vaccine("PCV booster",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool))
        
        //EighteenMonths
        VaccinationSchedule.append(Vaccine("DTwP B1/DTaP B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool))
        VaccinationSchedule.append(Vaccine("IPV B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool))
        VaccinationSchedule.append(Vaccine("B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool))
        
        //TwoYears
        VaccinationSchedule.append(Vaccine("Booster of Typhoid",UserDetails.VaccinationDates.twoYearDate!,twoYearBool))
        VaccinationSchedule.append(Vaccine("Conjugate Vaccine",UserDetails.VaccinationDates.twoYearDate!,twoYearBool))
        
        //SixYears
        VaccinationSchedule.append(Vaccine("DTwP B2/DTaP B2",UserDetails.VaccinationDates.sixYearDate!,sixYearBool))
        VaccinationSchedule.append(Vaccine("OPV 3",UserDetails.VaccinationDates.sixYearDate!,sixYearBool))
        VaccinationSchedule.append(Vaccine("Varicella 2",UserDetails.VaccinationDates.sixYearDate!,sixYearBool))
        VaccinationSchedule.append(Vaccine("MMR 3",UserDetails.VaccinationDates.sixYearDate!,sixYearBool))
        
        //TwelveYears
        VaccinationSchedule.append(Vaccine("Tdap/Td",UserDetails.VaccinationDates.twelveYearDate!,twelveYearBool))
        VaccinationSchedule.append(Vaccine("HPV",UserDetails.VaccinationDates.twelveYearDate!,twelveYearBool))
        
        setNotifications()
    }
    
    func setNotifications()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        for Vaccine in VaccinationSchedule
        {
            delegate.scheduleNotifications(Vaccine.vaccineDate, Vaccine.vaccineName)
        }
        
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
