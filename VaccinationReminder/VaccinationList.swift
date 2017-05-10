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
    var birthDate : Date = Date(timeIntervalSinceNow: 0)
    
    func setVaccineList()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: birthDate)
        let sixWeeksDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 42, to: birthDate)!)
        let tenWeeksDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 70, to: birthDate)!)
        let fourteenWeeksDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 98, to: birthDate)!)
        let sixMonthsDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: 6, to: birthDate)!)
        let nineMonthsDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: 9, to: birthDate)!)
        let oneYearDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 1, to: birthDate)!)
        let fifteenMonthsDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: 15, to: birthDate)!)
        let eighteenMonthsDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: 18, to: birthDate)!)
        let twoYearDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 2, to: birthDate)!)
        let sixYearDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 6, to: birthDate)!)
        let twelveYearDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: 12, to: birthDate)!)

        
        //birth
        VaccinationSchedule.append(Vaccine("BCG",date,true))
        VaccinationSchedule.append(Vaccine("OPV 0",date,true))
        VaccinationSchedule.append(Vaccine("Hep-B 1",date,true))
        
        //SixWeeks
        VaccinationSchedule.append(Vaccine("DTwP-1",sixWeeksDate,true))
        VaccinationSchedule.append(Vaccine("IPV 1",sixWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Hep-B 2",sixWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Hib 1",sixWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Rotavirus 1",sixWeeksDate,true))
        VaccinationSchedule.append(Vaccine("PCV 1",sixWeeksDate,true))
        
        //TenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 2",tenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("IPV 2",tenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Hib 2",tenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Rotavirus 2",tenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("PCV 2",tenWeeksDate,true))
        
        //FourteenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 3",fourteenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("IPV 3",fourteenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Hib 3",fourteenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("Rotavirus 3",fourteenWeeksDate,true))
        VaccinationSchedule.append(Vaccine("PCV 3",fourteenWeeksDate,true))
        
        //SixMonths
        VaccinationSchedule.append(Vaccine("OPV 1",sixMonthsDate,true))
        VaccinationSchedule.append(Vaccine("Hep-B 3",sixMonthsDate,true))
        
        //NineMonths
        VaccinationSchedule.append(Vaccine("OPV 2",nineMonthsDate,true))
        VaccinationSchedule.append(Vaccine("MMR-1",nineMonthsDate,true))
        
        //OneYear
        VaccinationSchedule.append(Vaccine("Typhoid Conjugate",oneYearDate,true))
        VaccinationSchedule.append(Vaccine("Hep-A 1",oneYearDate,true))
        
        //FifteenMonths
        VaccinationSchedule.append(Vaccine("MMR 2",fifteenMonthsDate,true))
        VaccinationSchedule.append(Vaccine("Varicella 1",fifteenMonthsDate,true))
        VaccinationSchedule.append(Vaccine("PCV booster",fifteenMonthsDate,true))
        
        //EighteenMonths
        VaccinationSchedule.append(Vaccine("DTwP B1/DTaP B1",eighteenMonthsDate,true))
        VaccinationSchedule.append(Vaccine("IPV B1",eighteenMonthsDate,true))
        VaccinationSchedule.append(Vaccine("B1",eighteenMonthsDate,true))
        
        //TwoYears
        VaccinationSchedule.append(Vaccine("Booster of Typhoid",twoYearDate,true))
        VaccinationSchedule.append(Vaccine("Conjugate Vaccine",twoYearDate,true))
        
        //SixYears
        
        VaccinationSchedule.append(Vaccine("DTwP B2/DTaP B2",sixYearDate,true))
        VaccinationSchedule.append(Vaccine("OPV 3",sixYearDate,true))
        VaccinationSchedule.append(Vaccine("Varicella 2",sixYearDate,true))
        VaccinationSchedule.append(Vaccine("MMR 3",sixYearDate,true))
        
        //TwelveYears
        VaccinationSchedule.append(Vaccine("Tdap/Td",twelveYearDate,true))
        VaccinationSchedule.append(Vaccine("HPV",twelveYearDate,true))
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
