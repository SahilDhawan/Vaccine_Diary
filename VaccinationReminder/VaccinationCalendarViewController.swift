//
//  VaccinationCalendarViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 25/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class VaccinationCalendarViewController: UIViewController {
    var vaccines = [Vaccine]()
    let inMonthDatesColor = UIColor.white
    let outMonthDatesColor = UIColor.gray
    let dateFormatter = DateFormatter()

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        vaccines = UserDetails.vaccinationList
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //navigationBar
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        dateFormatter.dateFormat = "yyyy"
        yearLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)
    }
    
}

extension VaccinationCalendarViewController :  JTAppleCalendarViewDelegate
{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell{
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "VaccinationCalendarCell", for: indexPath) as! VaccinationCalendarCell
        cell.dateLabel.text = cellState.text
        for vaccine in vaccines
        {
            
            if cellState.dateBelongsTo == .thisMonth
            {
                cell.dateLabel.textColor = inMonthDatesColor
                
                if date == vaccine.vaccineDate
                {
                    cell.view.isHidden = false
                }
            }
            else
            {
                cell.dateLabel.textColor = outMonthDatesColor
                cell.view.isHidden = true
            }
        }
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first?.date
        dateFormatter.dateFormat = "yyyy"
        yearLabel.text = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date!)
    }
    
}
extension VaccinationCalendarViewController : JTAppleCalendarViewDataSource
{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let currentDateString = dateFormatter.string(from: Date())
        let startDate = dateFormatter.date(from : currentDateString)
        let endDate = dateFormatter.date(from: "01-01-2050")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
}


