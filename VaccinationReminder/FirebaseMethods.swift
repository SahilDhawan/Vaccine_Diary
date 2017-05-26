//
//  FirebaseMethods.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 20/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseMethods : NSObject
{
    let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
    
    func getDataFromFirebase(_ completionHandler : @escaping(_ name : String?, _ birthDate : String?)-> Void)
    {
        //Updating Label Values
        ref.child("users").child(UserDetails.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let userName = value?["username"] as? String
            let birthString = value?["birthDate"] as? String
            completionHandler(userName,birthString)
        })
    }
    
    
    func FirebaseUpdateData(_ completionHandler: @escaping(_ success : Bool)->Void)
    {
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        ref.child("users").child(UserDetails.uid).updateChildValues(saveDict) { (error, databaseRef) in
            if error == nil
            {
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
            }
        }
    }
    
    func FirebaseWriteData(_ completionHandler: @escaping(_ success : Bool)->Void)
    {
        var saveDict = [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDict["username"] =  UserDetails.userName
        saveDict["birthDate"] = dateFormatter.string(from: UserDetails.userBirthDate)
        ref.child("users").child(UserDetails.uid).setValue(saveDict) { (error, databaseRef) in
            if error == nil
            {
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
            }
        }
    }
}
