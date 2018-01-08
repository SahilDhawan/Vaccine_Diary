//
//  CreditsViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 15/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var tableHeaderArray = ["CocoaPod Libraries" , "Assets"]
    var librariesArray = ["Firebase Auth and Database" , "Google Places" , "Facebook Login Kit" , "Alamofire" , "Alamofire ObjectMapper"]
    var assetsArray = ["Flat Icons" , "Icons 8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.navigationItem.title = "Credits"
        setupTableView()
    }
    
    func setupTableView(){
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.dataSource = self
    }
}

extension CreditsViewController : UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return librariesArray.count
        } else {
            return assetsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditsCell")
        if indexPath.section == 0 {
            cell?.textLabel?.text = librariesArray[indexPath.item]
        } else {
            cell?.textLabel?.text = assetsArray[indexPath.item]
        }
        cell?.imageView?.image = UIImage(named : "dot")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaderArray[section]
    }
}
