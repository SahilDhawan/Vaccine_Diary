//
//  InitialCollectionViewCell.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 31/12/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class InitialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var cellView : UIView!
    
    func setupCollectionViewCell(image : String , title : String , description : String) {
        imageView.image = UIImage(named : image)
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = colors.whiteColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = colors.whiteColor
        cellView.clipsToBounds = true
        cellView.layer.cornerRadius = 30
        cellView.layer.borderWidth = 2.5
        cellView.layer.borderColor = colors.placeholderColor.cgColor
        
    }
}
