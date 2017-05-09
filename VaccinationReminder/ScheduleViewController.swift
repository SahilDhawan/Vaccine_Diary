//
//  ScheduleViewController.swift
//
//
//  Created by Sahil Dhawan on 08/05/17.
//
//

import UIKit

var tableSize : Int = 0
var VaccinationSchedule : [Vaccine] = []

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting Details from Vaccination List
        let vaccineObject = VaccinationList()
        vaccineObject.setVaccineList()
        tableSize = vaccineObject.getTableSize()
        VaccinationSchedule = vaccineObject.getVaccineDetails()
        
        //tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        //changing color of NavigationBar
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //removing extra padding from top
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
    }
}
extension ScheduleViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vaccine = VaccinationSchedule[indexPath.item]
        //Cell Details
        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineCell")
        cell?.textLabel?.text = vaccine.vaccineName
        cell?.detailTextLabel?.text = vaccine.vaccineDate
        
        if !vaccine.vaccineCompletion
        {
            cell?.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        }
        else
        {
            cell?.backgroundColor = UIColor(colorLiteralRed: 204/255, green: 255/255, blue: 102/255, alpha: 1)
        }
        return cell!
    }
}
extension ScheduleViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
}