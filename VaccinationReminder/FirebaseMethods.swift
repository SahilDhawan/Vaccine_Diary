//
//  FirebaseMethods.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 20/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class FirebaseMethods : NSObject {
    let ref = Database.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
    
    func getDataFromFirebase(_ completionHandler : @escaping(_ name : String?, _ birthDate : String? , _ time : String? , _ userGender : String?)-> Void) {
        //Updating Label Values
        ref.child("users").child(UserDetails.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userName = value?["username"] as? String
            let birthString = value?["birthDate"] as? String
            let notificationTime = value?["notificationTime"] as? String
            let userGender = value?["userGender"] as? String
            completionHandler(userName,birthString,notificationTime,userGender)
        })
    }
    
    
    func FirebaseUpdateData(_ completionHandler: @escaping(_ success : Bool)->Void) {
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        dateFormatter.dateFormat = "h:mm a"
        saveDict["notificationTime"] = dateFormatter.string(from: UserDetails.notificationTime)
        saveDict["userGender"] = UserDetails.userGender
        ref.child("users").child(UserDetails.uid).updateChildValues(saveDict) { (error, databaseRef) in
            if error == nil {
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        dateFormatter.dateFormat = "h:mm a"
        saveDict["notificationTime"] = dateFormatter.string(from: UserDetails.notificationTime)
        saveDict["userGender"] = UserDetails.userGender
        ref.child("users").child(UserDetails.uid).setValue(saveDict) { (error, databaseRef) in
            if error == nil {
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    func FirebasePasswordReset(_ email : String , completionHandler : @escaping(_ bool : Bool, _ error : Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                completionHandler(false,error!)
            } else {
                completionHandler(true,nil)
            }
        })
    }
    
}
