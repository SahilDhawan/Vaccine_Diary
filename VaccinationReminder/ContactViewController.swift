//
//  ContactViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 15/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController {
    
    @IBOutlet weak var subjectTextField : UITextField!
    @IBOutlet weak var contentTextView : UITextView!
    @IBOutlet weak var sendButton : UIButton!
    @IBOutlet weak var contentTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        setupTextFields()
        setupSendButton()
        self.navigationItem.title = "Contact Developer"
    }
    
    func setupTextFields(){
        subjectTextField.delegate = self
        subjectTextField.placeholder = "Subject"
        contentTextField.isUserInteractionEnabled = false
    }
    
    func setupTextViews(){
        contentTextView.textColor = colors.placeholderColor
        contentTextView.text = "Mail Subject"
        contentTextView.backgroundColor = colors.clearColor
        contentTextView.delegate = self
        contentTextView.addDoneButton()
    }
    
    func setupSendButton(){
        sendButton.setTitle("SEND MAIL", for: .normal)
        sendButton.setTitleColor(colors.whiteColor, for: .normal)
        sendButton.backgroundColor = colors.navyBlueColor
    }
    
    @IBAction func sendButtonPressed(sender : AnyObject) {
        if subjectTextField.text == "" {
            showAlert("Subject of the mail cannot be empty!")
        } else if contentTextView.text == "Mail Subject" {
            showAlert("Content of the mail cannot be empty!")
        } else {
            let mailController = configureMailComponentViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailController, animated: true, completion: nil)
            } else {
                showAlert("Could not send mail!")
            }
        }
    }
    
    func configureMailComponentViewController() -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.delegate = self
        mailController.setToRecipients(["sahildhawan2012@icloud.com"])
        mailController.setSubject(subjectTextField.text!)
        mailController.setMessageBody(contentTextView.text!, isHTML: false)
        return mailController
    }
}

extension ContactViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ContactViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Mail Subject"{
            textView.text = ""
        }
        textView.textColor = colors.blackColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = colors.placeholderColor
            textView.text = "Mail Subject"
        } else {
            textView.textColor = colors.blackColor
        }
    }
}

extension ContactViewController : MFMailComposeViewControllerDelegate , UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
