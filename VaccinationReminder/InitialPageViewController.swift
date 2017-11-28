//
//  InitialPageViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 28/11/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class InitialPageViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var crossButton : UIButton!
    @IBOutlet weak var pageControl : UIPageControl!
    
    var image : UIImage?
    var currentPage : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController(image: image!, currentPage: currentPage!)
    }
    
    @IBAction func crossButtonPressed(_ sender : Any){
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
    }
    
    func setupViewController(image : UIImage, currentPage : Int){
        imageView.image = image
        pageControl.currentPage = currentPage
    }
}
