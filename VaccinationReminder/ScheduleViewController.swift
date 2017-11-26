//
//  ScheduleViewController.swift
//
//
//  Created by Sahil Dhawan on 08/05/17.
//
//

import UIKit
import UserNotifications
var tableSize : Int = 0

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var nextVaccinationLabel : UILabel!
    
    var nextVaccination : String?
    var selectedVaccine : Vaccine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        addActivityViewController(activityView,true)
        setupViewController()
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
        self.nextVaccinationLabel.text = ""
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        } else {
            setUpCollectionView()
            getDataFromFirebase()
        }
    }
    
    func setupNextVaccinationLabel(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        for i in 0..<UserDetails.vaccinationList.count {
            if i == 0 {
                let vaccine = UserDetails.vaccinationList.first
                if (vaccine?.vaccineDate)! > Date() {
                    self.nextVaccinationLabel.text = dateFormatter.string(from: (vaccine?.vaccineDate)!)
                    self.nextVaccination = dateFormatter.string(from: (vaccine?.vaccineDate)!)
                    break
                }
            } else if (UserDetails.vaccinationList[i].vaccineDate) > Date() && (UserDetails.vaccinationList[i-1].vaccineDate) <= Date(){
                self.nextVaccinationLabel.text = dateFormatter.string(from : UserDetails.vaccinationList[i].vaccineDate)
                self.nextVaccination = dateFormatter.string(from : UserDetails.vaccinationList[i].vaccineDate)
                break
            }
        }
        self.addQuickAction()
    }
    
    func setUpCollectionView() {
        //removing extra padding from top
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        let cellSize = CGSize(width: self.view.frame.width - 20, height: 55)
        let spacing  : CGFloat = 5.0
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = cellSize
        
        collectionView.dataSource = self
        collectionView.delegate = self
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
            tableSize = UserDetails.vaccinationList.count

            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setupNextVaccinationLabel()
                self.addActivityViewController(self.activityView,false)
            }
        }
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let vaccine = UserDetails.vaccinationList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineCell", for: indexPath) as! VaccineCollectionViewCell
        cell.vaccineLabel?.text = vaccine.vaccineName
        cell.dateLabel?.text = dateFormatter.string(for:vaccine.vaccineDate)
        
        if !vaccine.vaccineCompletion {
            cell.vaccineImageView.image = UIImage(named: "orangeVaccine")
        }else {
            cell.vaccineImageView.image = UIImage(named: "greenVaccine")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! VaccineDetailTableViewController
        destination.currentVaccine = selectedVaccine
    }
}

extension ScheduleViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vaccine = UserDetails.vaccinationList[indexPath.item]
        selectedVaccine = vaccine
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
}
