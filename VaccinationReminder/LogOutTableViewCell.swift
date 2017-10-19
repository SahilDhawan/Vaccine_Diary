//
//  LogOutTableViewCell.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 20/10/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {

    @IBOutlet weak var logOutButton : UIButton!
    
    override func awakeFromNib() {
        setupLogOutButton()
    }
    
    func setupLogOutButton(){
        logOutButton.backgroundColor = colors.redColor
        logOutButton.setTitle("LOG OUT", for: .normal)
        logOutButton.setTitleColor(colors.whiteColor, for: .normal)
    }

    
    
}
