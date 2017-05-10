//
//  VaccinationCalendarController.swift
//
//
//  Created by Sahil Dhawan on 09/05/17.
//
//

import UIKit
import FSCalendar

class VaccinationCalendarController: UIViewController {
    let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //select calendar dates
        calendar.select(UserDetails.userBirthDate ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.sixWeeksDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.tenWeeksDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.fourteenWeeksDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.sixMonthsDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.nineMonthsDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.oneYearDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.fifteenMonthsDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.eighteenMonthsDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.twoYearDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.sixYearDate! ,scrollToDate: false)
        calendar.select(UserDetails.VaccinationDates.twelveYearDate! ,scrollToDate: false)
        
        
    }
}
