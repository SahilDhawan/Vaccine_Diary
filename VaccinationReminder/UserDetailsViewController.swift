//
//  UserDetailsViewController.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 08/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var activityView1: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveDetailsButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var notificationTimeField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    let datePicker : UIDatePicker = UIDatePicker()
    let timePicker : UIDatePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //delegates
        nameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        
        //datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDateChange(sender:)), for: UIControlEvents.valueChanged)
        
        //timePicker
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(handleTimeChange(sender:)), for: UIControlEvents.valueChanged)
        
        //activityIndicatorView
        addActivityViewController(activityView, true)
        
        //datePickerToolbar
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.barStyle = .default
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resign(sender:)))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor =  colors.darkBlueColor
        toolbar.sizeToFit()
        
        //timePickerToolbar
        let timeToolbar = UIToolbar()
        timeToolbar.isTranslucent = false
        timeToolbar.barStyle = .default
        let timeDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignTime(sender:)))
        timeToolbar.setItems([timeDoneButton], animated: true)
        timeToolbar.isUserInteractionEnabled = true
        timeToolbar.tintColor =  colors.darkBlueColor
        timeToolbar.sizeToFit()
        
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = toolbar
        
        notificationTimeField.inputView = timePicker
        notificationTimeField.inputAccessoryView = timeToolbar
        
        getDataFromFirebase()
        self.setupNavigationBar()
        
        
        //card View
        cardView.dropShadow()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 20.0
        
        //imagePicker
        imagePicker.delegate = self
        
        //getting user image
        if let imageData = defaults.object(forKey: "userImage") as? NSData {
            let image = UIImage(data: imageData as Data)
            userImage.image = image
        } else {
            self.userImage.image = UIImage(named: "userIcon")
        }
    }
    
    func resign(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: Date())
        let currentString = dateFormatter.string(from: datePicker.date)
        if dateString == currentString {
            dateOfBirthTextField.text = dateString
        }
        self.view.endEditing(true)
        
    }
    
    func resignTime(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: Date())
        let currentString = dateFormatter.string(from: timePicker.date)
        if dateString == currentString {
            notificationTimeField.text = dateString
        }
        self.view.endEditing(true)
    }
    
    func getDataFromFirebase() {
        let ref = FIRDatabase.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(UserDetails.uid) {
                let firebase = FirebaseMethods()
                firebase.getDataFromFirebase { (userName, birthDate , time) in
                    self.addActivityViewController(self.activityView, false)
                    self.nameTextField.text = userName
                    self.dateOfBirthTextField.text = birthDate
                    self.notificationTimeField.text = time
                }
            }
            else {
                self.addActivityViewController(self.activityView, false)
            }
        })
    }
    
    func handleDateChange(sender : UIDatePicker) {
        UserDetails.userBirthDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: UserDetails.userBirthDate)
        dateOfBirthTextField.text = dateString
    }
    
    func handleTimeChange(sender : UIDatePicker) {
        UserDetails.notificationTime = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: UserDetails.notificationTime)
        notificationTimeField.text = dateString
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Text Field Placeholder
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : colors.grayColor])
        dateOfBirthTextField.attributedPlaceholder = NSAttributedString(string: "Date Of Birth", attributes: [NSForegroundColorAttributeName : colors.grayColor])
        notificationTimeField.attributedPlaceholder = NSAttributedString(string: "Notification Time", attributes: [NSForegroundColorAttributeName : colors.grayColor])
        
        //cancel button
        if UserDetails.update {
            cancelButton.isEnabled = true
            saveDetailsButton.setTitle("UPDATE DETAILS", for: .normal)
            detailsLabel.isHidden = true
        }
        else {
            cancelButton.isEnabled = false
            detailsLabel.isHidden = false
            
        }
        
        //logOut New User
        if UserDetails.logOut {
            UserDetails.logOut = false
            self.dismiss(animated: true, completion: nil)
        }
        activityView1.isHidden = true
    }
    
    
    @IBAction func saveDetailsPressed(_ sender: Any) {
        UserDetails.userName = nameTextField.text!
        if userImage.image != UIImage(named : "userIcon") {
            let imageData = UIImageJPEGRepresentation(userImage.image!, 1)
            defaults.set(imageData, forKey: "userImage")
        }
        savingDetailsToFirebase()
        return
    }
    
    func savingDetailsToFirebase() {
        self.activityView1.isHidden = false
        addActivityViewController(self.activityView1, true)
        let fir = FirebaseMethods()
        
        //network connection
        if Reachability().isConnectedToNetwork() == false {
            self.addActivityViewController(self.activityView1, false)
            showAlert("No Internet Connection")
        } else {
            if nameTextField.text == "" || dateOfBirthTextField.text == "" || notificationTimeField.text == "" {
                self.showAlert("Fields cannot be empty !")
                self.addActivityViewController(self.activityView1, false)
            } else {
                if UserDetails.update {
                    fir.FirebaseUpdateData({ (success) in
                        if success {
                            self.addActivityViewController(self.activityView1, false)
                            self.performSegue(withIdentifier: "userCreationSegue", sender: self)
                        }
                        else {
                            self.addActivityViewController(self.activityView1, false)
                            self.showAlert("Could not update data")
                        }
                    })
                } else {
                    fir.FirebaseWriteData({ (success) in
                        if success {
                            self.addActivityViewController(self.activityView1, false)
                            self.performSegue(withIdentifier: "userCreationSegue", sender: self)
                        } else {
                            self.addActivityViewController(self.activityView1, false)
                            self.showAlert("Could not update data")
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        UserDetails.update = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Vaccine Diary", message: "Choose an option", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let galleryAction = UIAlertAction(title: "Photo Album", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let removeAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            self.userImage.image = UIImage(named: "userIcon")
            self.defaults.removeObject(forKey: "userImage")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UserDetailsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserDetailsViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImage.contentMode = .scaleAspectFit
        userImage.image = image!
        
        dismiss(animated: true, completion: nil)
    }
}
