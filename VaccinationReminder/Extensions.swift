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
        self.navigationController?.navigationBar.barTintColor = colors.darkBlueColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : colors.whiteColor]
        self.navigationController?.navigationBar.tintColor = colors.whiteColor
    }
}



