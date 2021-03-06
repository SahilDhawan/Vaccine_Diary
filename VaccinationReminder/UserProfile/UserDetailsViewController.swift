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
    @IBOutlet weak var segmentController : UISegmentedControl!
    
    let datePicker : UIDatePicker = UIDatePicker()
    let timePicker : UIDatePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    let defaults = UserDefaults.standard
    let userGenderArray = ["Boy" , "Girl"]
    
    fileprivate func setupUserImage() {
        //getting user image
        if let imageData = defaults.object(forKey: "userImage") as? NSData {
            let image = UIImage(data: imageData as Data)
            userImage.image = image
        } else {
            if UserDetails.userGender == "Boy" {
                self.userImage.image = UIImage(named: "boy")
            } else {
                self.userImage.image = UIImage(named: "girl")
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //delegates
        nameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        
        //background Colors
        self.view.backgroundColor = colors.clearColor
        let gradient = CAGradientLayer()
        gradient.colors = [colors.darkBlueColor.cgColor , loginColors.pinkColor.cgColor]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
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
        
        //segmentController
        let font = UIFont.systemFont(ofSize: 18.0)
        segmentController.setTitleTextAttributes([NSFontAttributeName : font], for: .normal)
        segmentController.clipsToBounds = true
        segmentController.layer.cornerRadius = 5
        
        //card View
        cardView.dropShadow()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 20.0
        
        //imagePicker
        imagePicker.delegate = self
        
        setupUserImage()
        
        userImage.clipsToBounds = true
        userImage.layer.borderColor = colors.whiteColor.cgColor
        userImage.layer.borderWidth = 1.0
        let height = userImage.frame.height
        let width = userImage.frame.width
        if height > width {
            userImage.layer.cornerRadius = height/2
        } else {
            userImage.layer.cornerRadius = width/2
        }
        
        userImage.backgroundColor = UIColor.clear
        
    }
    
    func resign(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentString = dateFormatter.string(from: datePicker.date)
        dateOfBirthTextField.text = currentString
        UserDetails.userBirthDate = datePicker.date
        self.view.endEditing(true)
        
    }
    
    func resignTime(sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let currentString = dateFormatter.string(from: timePicker.date)
        notificationTimeField.text = currentString
        UserDetails.notificationTime = timePicker.date
        self.view.endEditing(true)
    }
    
    func getDataFromFirebase() {
        let ref = Database.database().reference(fromURL: "https://vaccinationreminder-e7f81.firebaseio.com/")
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(UserDetails.uid) {
                let firebase = FirebaseMethods()
                firebase.getDataFromFirebase { (userName, birthDate , time , userGender) in
                    self.addActivityViewController(self.activityView, false)
                    self.nameTextField.text = userName
                    self.dateOfBirthTextField.text = birthDate
                    self.notificationTimeField.text = time
                    if userGender == "Boy" {
                        self.segmentController.selectedSegmentIndex = 0
                    } else {
                        self.segmentController.selectedSegmentIndex = 1
                    }
                    self.setupUserImage()
                }
            }
            else {
                self.addActivityViewController(self.activityView, false)
            }
        })
    }
    
    func handleDateChange(sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: sender.date)
        dateOfBirthTextField.text = dateString
    }
    
    func handleTimeChange(sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: sender.date)
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
        
        if userImage.image != UIImage(named : "girl") ||  userImage.image != UIImage(named : "boy") {
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
                UserDetails.userGender = userGenderArray[segmentController.selectedSegmentIndex]
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
    
    @IBAction func segmentValueChanged(){
        if segmentController.selectedSegmentIndex == 0 {
            userImage.image = UIImage(named : "boy")
        } else {
            userImage.image = UIImage(named : "girl")
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
            if UserDetails.userGender == "Boy" {
                self.userImage.image = UIImage(named: "boy")
            } else {
                self.userImage.image = UIImage(named: "girl")
            }
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
        
        userImage.clipsToBounds = true
        userImage.layer.borderColor = colors.whiteColor.cgColor
        userImage.layer.borderWidth = 1.0
        let height = userImage.frame.height
        let width = userImage.frame.width
        if height > width {
            userImage.layer.cornerRadius = height/2
        } else {
            userImage.layer.cornerRadius = width/2
        }
        
        dismiss(animated: true, completion: nil)
    }
}
