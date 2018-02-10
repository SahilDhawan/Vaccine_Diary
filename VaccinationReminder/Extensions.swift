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
            activityView.isHidden = false
            self.view.addSubview(activityView)
            activityView.startAnimating()
        } else {
            self.view.willRemoveSubview(activityView)
            activityView.isHidden = true
            activityView.stopAnimating()
        }
    }
    
    func setupNavigationBar() {
        
//        self.navigationController?.navigationBar.barTintColor = colors.darkBlueColor
                self.navigationController?.navigationBar.barTintColor = colors.whiteColor

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : colors.blackColor]
        self.navigationController?.navigationBar.tintColor = colors.darkBlueColor
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
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

