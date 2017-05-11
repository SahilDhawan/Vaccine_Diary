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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
                    self.tableView.reloadData()
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
