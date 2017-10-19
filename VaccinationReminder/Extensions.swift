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

extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UITextView {
    
    func addDoneButton(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        doneButton.tintColor = colors.darkBlueColor
        toolbar.items = [doneButton]
        self.inputAccessoryView = toolbar
    }
    
    func doneButtonPressed(){
        self.resignFirstResponder()
    }
}

