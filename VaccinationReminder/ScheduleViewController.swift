//
//  ScheduleViewController.swift
//
//
//  Created by Sahil Dhawan on 08/05/17.
//
//

import UIKit

var tableSize : Int = 0

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetching Date from FireBase
        let fir = FirebaseMethods()
        fir.getDataFromFirebase { (name, birthDate) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            let vaccineObject = VaccinationList()
            vaccineObject.setVaccineList()
            tableSize = vaccineObject.getTableSize()
            UserDetails.vaccinationList = vaccineObject.getVaccineDetails()
            DispatchQueue.main.async
                {
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    self.addActivityViewController(self.activityView,false)
            }
        }
        
        
        //changing color of NavigationBar
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //removing extra padding from top
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addActivityViewController(activityView,true)
        
        if Reachability().isConnectedToNetwork() == false
        {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
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
        
        let vaccine = UserDetails.vaccinationList[indexPath.item]
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

