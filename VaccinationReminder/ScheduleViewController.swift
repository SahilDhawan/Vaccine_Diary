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
    @IBOutlet weak var vaccineDetail: UIView!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nextVaccinationLabel : UILabel!
    
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
                    break
                }
            } else if (UserDetails.vaccinationList[i].vaccineDate) > Date() && (UserDetails.vaccinationList[i-1].vaccineDate) <= Date(){
                self.nextVaccinationLabel.text = dateFormatter.string(from : UserDetails.vaccinationList[i].vaccineDate)
                break
            }
        }
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        vaccineDetail.isHidden = true
        collectionView.alpha = 1.0
        collectionView.isUserInteractionEnabled = true
        
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
}

extension ScheduleViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let vaccine = UserDetails.vaccinationList[indexPath.item]
        vaccineDetail.isHidden = false
        detailName.text = vaccine.vaccineName
        detailDate.text = dateFormatter.string(for:vaccine.vaccineDate)
        textView.scrollRangeToVisible(NSMakeRange(0,0))
        textView.text = vaccine.vaccinationDetail
        if vaccine.vaccineCompletion {
            vaccineDetail.backgroundColor = colors.greenColor
        } else {
            vaccineDetail.backgroundColor = colors.orangeColor
        }
        collectionView.alpha = 0.3
        collectionView.isUserInteractionEnabled = false
    }
}
