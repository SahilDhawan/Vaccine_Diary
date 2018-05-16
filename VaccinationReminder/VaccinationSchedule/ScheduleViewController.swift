//
//  ScheduleViewController.swift
//
//
//  Created by Sahil Dhawan on 08/05/17.
//
//

import UIKit
import UserNotifications

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var nextVaccination : String?
    var selectedVaccine : Vaccine?
    var vaccineArray : [Vaccine] = []
    var searchVaccineArray : [Vaccine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        addActivityViewController(activityView,true)
        setupViewController()
        setupTableView()
        setupSearchBar()
    }
    
    // if the user updates notification time or birth date
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDetails.update {
            setupViewController()
            UserDetails.update = false
        }
    }
    
    func addQuickAction(){
        let icon = UIApplicationShortcutIcon(type: .date)
        let item = UIApplicationShortcutItem(type: "dhawan-sahil.VaccinationReminder", localizedTitle: "Next Vaccination", localizedSubtitle: nextVaccination, icon: icon, userInfo: nil)
        UIApplication.shared.shortcutItems = [item]
    }
    
    func setupViewController() {
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        } else {
            //            setUpCollectionView()
            getDataFromFirebase()
        }
    }
    
    fileprivate func setupSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
    //setup table view
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        let scheduleNib = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(scheduleNib, forCellReuseIdentifier: "scheduleCell")
    }
    
    func setupNextVaccinationLabel(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        for i in 0..<UserDetails.vaccinationList.count {
            if i == 0 {
                let vaccine = UserDetails.vaccinationList.first
                if (vaccine?.vaccineDate)! > Date() {
                    self.nextVaccination = dateFormatter.string(from: (vaccine?.vaccineDate)!)
                    UserDetails.completedVaccines = i
                    break
                }
            } else if (UserDetails.vaccinationList[i].vaccineDate) > Date() && (UserDetails.vaccinationList[i-1].vaccineDate) <= Date(){
                self.nextVaccination = dateFormatter.string(from : UserDetails.vaccinationList[i].vaccineDate)
                UserDetails.completedVaccines = i
                break
            }
        }
        
        UserDetails.nextVaccination = self.nextVaccination!
        self.addQuickAction()
    }
    
    func setupVaccinationList(){
        var vaccinationList : [String : String] = [:]
        for vaccine in UserDetails.vaccinationList {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let date = dateFormatter.string(from: vaccine.vaccineDate)
            vaccinationList[vaccine.vaccineName] = date
        }
        
        UserDetails.firebaseVaccination = vaccinationList
        
        FirebaseMethods().FirebaseUpdateData { (bool) in
            if bool {
                self.showAlert("Data Written to Firebase Successfully")
            } else {
                self.showAlert("Error Occured")
            }
        }
    }
    
    func getDataFromFirebase(){
        self.addActivityViewController(self.activityView,true)
        
        let fir = FirebaseMethods()
        fir.getDataFromFirebase { (name, birthDate,time,userGender) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            dateFormatter.dateFormat = "h:mm a"
            let vaccineObject = VaccinationList()
            UserDetails.notificationTime = dateFormatter.date(from: time!)!
            vaccineObject.setVaccineList()
            vaccineObject.setNotifications()
            self.vaccineArray = UserDetails.vaccinationList
            self.searchVaccineArray = self.vaccineArray
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupNextVaccinationLabel()
                if UserDetails.firebaseVaccination.count == 0 {
                    self.setupVaccinationList()
                }
                self.addActivityViewController(self.activityView,false)
            }
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVaccineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let vaccine = searchVaccineArray[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        cell.vaccineLabel?.text = vaccine.vaccineName
        cell.dateLabel?.text = dateFormatter.string(for:vaccine.vaccineDate)
        
        
        let calendarUnit : Set<Calendar.Component> = [.day,.month,.year]
        let difference = NSCalendar.current.dateComponents(calendarUnit, from: Date(), to: vaccine.vaccineDate)
        
        if let days = difference.day {
            if days > 0 {
                if days == 1 {
                    cell.timeLabel.text = "in \(days) day"
                } else {
                    cell.timeLabel.text = "in \(days) days"
                }
            } else if days < 0 {
                if days == -1 {
                    cell.timeLabel.text = "\(-days) day ago"
                } else {
                    cell.timeLabel.text = "\(-days) days ago"
                }
            }
        }
        
        if let month = difference.month {
            if month > 0 {
                if month == 1 {
                    cell.timeLabel.text = "in \(month) month"
                } else {
                    cell.timeLabel.text = "in \(month) months"
                }
            } else if month < 0 {
                if month == -1 {
                    cell.timeLabel.text = "\(-month) month ago"
                } else {
                    cell.timeLabel.text = "\(-month) months ago"
                }
            }
        }
        
        if let year = difference.year {
            if year > 0 {
                if year == 1 {
                    cell.timeLabel.text = "in \(year) year"
                } else {
                    cell.timeLabel.text = "in \(year) years"
                }
            } else if year < 0 {
                if year == -1 {
                    cell.timeLabel.text = "\(-year) year ago"
                } else {
                    cell.timeLabel.text = "\(-year) years ago"
                }
            }
        }
        
        if !vaccine.vaccineCompletion {
            cell.vaccineImageView?.image = UIImage(named: "vacRed")
            cell.vaccineLabel.textColor = colors.orangeColor
        }else {
            cell.vaccineImageView?.image = UIImage(named: "vacGreen")
            cell.vaccineLabel.textColor = colors.greenColor
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! VaccineDetailTableViewController
        destination.currentVaccine = selectedVaccine
    }
}

extension ScheduleViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedVaccine = searchVaccineArray[indexPath.item]
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: UISearchBarDelegate
extension ScheduleViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchVaccineArray = []
        if let searchText = searchBar.text {
            if searchText == "" {
                self.searchVaccineArray = self.vaccineArray
            } else {
                for vaccine in self.vaccineArray {
                    let vaccineLabel = vaccine.vaccineName
                    if vaccineLabel.lowercased().contains(searchText.lowercased()) {
                        self.searchVaccineArray.append(vaccine)
                    }
                }
            }
        } else {
            self.searchVaccineArray = self.vaccineArray
        }
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
}
