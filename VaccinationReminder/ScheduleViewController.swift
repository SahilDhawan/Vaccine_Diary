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
        
       
        
        //changing color of NavigationBar
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //removing extra padding from top
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        
        //setup Notifications
        VaccinationList().setNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fir = FirebaseMethods()
        fir.getDataFromFirebase { (name, birthDate) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            let vaccineObject = VaccinationList()
            vaccineObject.setVaccineList()
            tableSize = vaccineObject.getTableSize()
            VaccinationSchedule = vaccineObject.getVaccineDetails()
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}
extension ScheduleViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let vaccine = VaccinationSchedule[indexPath.item]
        //Cell Details
        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineCell") as! VaccineTableViewCell
        cell.vaccineLabel?.text = vaccine.vaccineName
        
        cell.dateLabel?.text = dateFormatter.string(for:vaccine.vaccineDate)
        
        if !vaccine.vaccineCompletion
        {
            cell.vaccineImageView.image = UIImage(named: "VacRed")
        }
        else
        {
            cell.vaccineImageView.image = UIImage(named: "VacGreen")

        }
        return cell
    }
}

