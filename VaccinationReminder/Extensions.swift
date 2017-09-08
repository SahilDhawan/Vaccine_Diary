//
//  Alert.swift
//
//
//  Created by Sahil Dhawan on 07/05/17.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ msg : String) {
        let alertController = UIAlertController(title: "Vaccine Diary", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addActivityViewController(_ activityView : UIActivityIndicatorView , _ bool : Bool) {
        if bool {
            self.view.addSubview(activityView)
            activityView.startAnimating()
        } else {
            self.view.willRemoveSubview(activityView)
            activityView.isHidden = true
            activityView.stopAnimating()
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 55/255, green: 71/255, blue: 97/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
}


