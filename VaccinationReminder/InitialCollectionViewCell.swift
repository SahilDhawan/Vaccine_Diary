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
    
    // setting the title, description and image of collection view cell
    func setupCollectionViewCell(image : String , title : String , description : String) {
        imageView.image = UIImage(named : image)
        titleLabel.text = title.uppercased()
        descriptionLabel.text = description
    }
}
