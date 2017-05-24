//
//  NearbyDoctorsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 09/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyDoctorsViewController: UIViewController{
    
    var doctorsArray : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    func googleApiFetch()
    {
        let googlePlaces = GooglePlaces()
        googlePlaces.fetchData(googlePlaces.createDoctorUrl()) { (data, error) in
            
            if error == nil
            {
                do
                {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let resultsArray = dict["results"] as! [[String:AnyObject]]
                    for result in resultsArray
                    {
                        self.doctorsArray.append(result["name"] as! String)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch
                {
                    self.showAlert("Unwanted error has occurred")
                }
            }
            else
            {
                self.showAlert((error?.localizedDescription)!)
                print(error.debugDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationBar
        let color = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue : 0)
        tableView.dataSource = self
        
        addActivityViewController(self.activityView, true)
        googleApiFetch()
        addActivityViewController(self.activityView, false)

    }
    
}

extension NearbyDoctorsViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyDoctorCell")
        cell?.textLabel?.text = doctorsArray[indexPath.item]
        return cell!
    }
}

