//
//  MoreViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 15/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit


class MoreViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    
    let segueArray = ["contactSegue" , "creditsSegue"]
    let tableNameArray = ["Contact Developer" , "Credits"]
    let tableImageArray = ["contact","credits"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.navigationItem.title = "More"
        setupTableView()
        self.activityView.isHidden = true
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "More"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Back"
    }
    
    func logOutButtonPressed(_ sender: Any) {
        addActivityViewController(activityView, true)
        let firebaseAuth = Auth.auth()
        do {
            UserDetails.logOut = true
            try firebaseAuth.signOut()
            FBSDKLoginManager().logOut()
            self.addActivityViewController(self.activityView, false)
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.window?.rootViewController = loginViewController
        }
        catch {
            self.addActivityViewController(self.activityView, false)
            showAlert("Problem Logging Out. Try again!")
        }
    }
}

extension MoreViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item < 2 {
            self.performSegue(withIdentifier: segueArray[indexPath.item], sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.item == 2{
            return false
        } else {
            return true
        }
    }
    
}

extension MoreViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logOutCell") as! LogOutTableViewCell
            cell.logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell")
            cell?.textLabel?.text = tableNameArray[indexPath.item]
            cell?.imageView?.image = UIImage(named: tableImageArray[indexPath.item])
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 2 {
            return 75
        } else {
            return 40
        }
    }
}
