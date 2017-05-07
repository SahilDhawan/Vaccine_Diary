//
//  Alert.swift
//  
//
//  Created by Sahil Dhawan on 07/05/17.
//
//

import Foundation
import UIKit

 extension UIViewController
{
    func showAlert(_ msg : String)
    {
        let alertController = UIAlertController(title: "VaxPlus", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
