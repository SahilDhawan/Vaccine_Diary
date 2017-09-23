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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var vaccineDetail: UIView!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addActivityViewController(activityView,true)
        
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView, false)
            showAlert("No Internet Connection")
        } else {
            setUpCollectionView()
            getDataFromFirebase()
            self.setupNavigationBar()
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
        let fir = FirebaseMethods()
        fir.getDataFromFirebase { (name, birthDate,time) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            UserDetails.userBirthDate = dateFormatter.date(from: birthDate!)!
            dateFormatter.dateFormat = "HH-mm"
            UserDetails.notificationTime = dateFormatter.date(from: time!)!
            let vaccineObject = VaccinationList()
            vaccineObject.setVaccineList()
            tableSize = vaccineObject.getTableSize()
            UserDetails.vaccinationList = vaccineObject.getVaccineDetails()
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
            cell.vaccineImageView.image = UIImage(named: "VacRed")
        }else {
            cell.vaccineImageView.image = UIImage(named: "VacGreen")
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
            vaccineDetail.backgroundColor = UIColor(colorLiteralRed: 164/255, green: 211/255, blue: 158/255, alpha: 1)
        } else {
             vaccineDetail.backgroundColor = UIColor(colorLiteralRed: 245/255, green: 142/255, blue: 92/255, alpha: 1)
        }
        collectionView.alpha = 0.3
        collectionView.isUserInteractionEnabled = false
    }
}
