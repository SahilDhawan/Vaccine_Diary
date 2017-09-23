//
//  FirebaseMethods.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 20/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseMethods : NSObject {
    let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
    
    func getDataFromFirebase(_ completionHandler : @escaping(_ name : String?, _ birthDate : String? , _ time : String?)-> Void) {
        //Updating Label Values
        ref.child("users").child(UserDetails.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let userName = value?["username"] as? String
            let birthString = value?["birthDate"] as? String
            let notificationTime = value?["notificationTime"] as? String
            completionHandler(userName,birthString,notificationTime)
        })
    }
    
    
    func FirebaseUpdateData(_ completionHandler: @escaping(_ success : Bool)->Void) {
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        dateFormatter.dateFormat = "HH-mm"
        saveDict["notificationTime"] = dateFormatter.string(from: UserDetails.notificationTime)
        ref.child("users").child(UserDetails.uid).updateChildValues(saveDict) { (error, databaseRef) in
            if error == nil {
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    func FirebaseWriteData(_ completionHandler: @escaping(_ success : Bool)->Void) {
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        dateFormatter.dateFormat = "HH-mm"
        saveDict["notificationTime"] = dateFormatter.string(from: UserDetails.notificationTime)
        ref.child("users").child(UserDetails.uid).setValue(saveDict) { (error, databaseRef) in
            if error == nil {
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
    }
}
