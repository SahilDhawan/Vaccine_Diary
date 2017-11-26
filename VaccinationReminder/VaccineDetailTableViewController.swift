//
//  VaccineDetailTableViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 26/11/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class VaccineDetailTableViewController: UITableViewController {

    @IBOutlet weak var vaccineDetailLabel : UILabel!
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var yearLabel : UILabel!
    @IBOutlet weak var calendarCollectionView : JTAppleCalendarView!
    @IBOutlet weak var vaccineNameLabel : UILabel!
    
    var currentVaccine : Vaccine?
    var vaccineDetailHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentVaccine?.vaccineName
        setupVaccineDetail()
        setupTableView()
        setupCalendarView()
    }
    
    func setupCalendarView(){
        calendarCollectionView.isUserInteractionEnabled = false
        calendarCollectionView.selectDates([(currentVaccine?.vaccineDate)!])
        calendarCollectionView.minimumLineSpacing = 0
        calendarCollectionView.minimumInteritemSpacing = 0
        calendarCollectionView.scrollToDate((currentVaccine?.vaccineDate)!)
    }
    
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }
    
    func handleCellColor( _ cell : JTAppleCell , _ cellState : CellState) {
        let calendarCell = cell as! VaccineDateCollectionViewCell
        if cellState.dateBelongsTo == .thisMonth {
            calendarCell.dateLabel.textColor = colors.blackColor
        } else {
            calendarCell.dateLabel.textColor = colors.grayColor
        }
    }
    
    func setupVaccineDetail(){
        vaccineDetailLabel.numberOfLines = 0
        vaccineDetailLabel.frame.size.height = 0
        vaccineDetailLabel.text = currentVaccine?.vaccinationDetail
        vaccineDetailLabel.sizeToFit()
        vaccineDetailLabel.frame.size.height = vaccineDetailLabel.frame.height
        vaccineDetailHeight = vaccineDetailLabel.frame.height
        
        vaccineNameLabel.text = currentVaccine?.vaccineName
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 360
        } else if indexPath.item == 2 {
            return vaccineDetailHeight
        } else {
            return 44.0
        }
    }
}

extension VaccineDetailTableViewController : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //todo
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        let startDate = dateFormatter.date(from: "2000 01 01")
        let endDate = dateFormatter.date(from: "2050 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! VaccineDateCollectionViewCell
        cell.dateLabel.text = cellState.text
        if cell.isSelected {
            if (currentVaccine?.vaccineCompletion)! {
                cell.backgroundColor = colors.greenColor
            } else {
                cell.backgroundColor = colors.orangeColor
            }
        } else {
            cell.backgroundColor = colors.whiteColor
        }
        handleCellColor(cell, cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        yearLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)
    }
}

