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
import StoreKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    
    let segueArray = ["contactSegue" , "creditsSegue"]
    let tableNameArray = ["Contact Developer" , "Credits" , "Refer to a Friend"]
    let tableImageArray = ["contact","credits","refer"]
    
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
        setupLogOutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "More"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Back"
    }
    
     func setupLogOutButton(){
        let logOutButton = UIButton(frame: CGRect(x: 25, y: 185, width: self.view.frame.width - 50, height: 40))
        logOutButton.setTitle("LOG OUT", for: .normal)
        logOutButton.backgroundColor = colors.redColor
        logOutButton.setTitleColor(colors.whiteColor, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed(_:)), for: .touchUpInside)
        let footerView = UIView(frame: CGRect(x: 0, y: 180, width: self.view.frame.width, height: 50))
        view.addSubview(logOutButton)
        tableView.tableFooterView = footerView
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
        } else {
            let appLink : String = "https://itunes.apple.com/in/app/vaccine-diary/id1318198568?mt=8"
            let activityViewController = UIActivityViewController(activityItems: [appLink], applicationActivities: [])
            self.present(activityViewController, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell")
        cell?.textLabel?.text = tableNameArray[indexPath.item]
        cell?.imageView?.image = UIImage(named: tableImageArray[indexPath.item])
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
}

