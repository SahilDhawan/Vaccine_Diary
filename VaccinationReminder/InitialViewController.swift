//
//  InitialViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 31/12/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var getStartedButton : UIButton!
    @IBOutlet weak var collectionViewFlowLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewFlowLayout()
        getStartedButton.isHidden = true
        collectionView.backgroundColor = colors.clearColor
        setupGetStartedButton()
        
        UIApplication.shared.statusBarStyle = .default

    }
    
    func setupBackgroundView(){
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            colors.placeholderColor.cgColor,
            colors.whiteColor.cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        
//        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
//        gradientChangeAnimation.duration = 2.0
//        gradientChangeAnimation.toValue = [
//            loginColors.orangeColor.cgColor,
//            loginColors.pinkColor.cgColor
//        ]
//        gradientChangeAnimation.fillMode = kCAFillModeForwards
//        gradientChangeAnimation.isRemovedOnCompletion = false
//        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupGetStartedButton(){
        getStartedButton.clipsToBounds = true
        getStartedButton.backgroundColor = colors.darkBlueColor
        getStartedButton.layer.cornerRadius = 15
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
    }
    
    func setupCollectionViewFlowLayout(){
        let spacing : CGFloat = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = spacing
        collectionViewFlowLayout.minimumLineSpacing = spacing
        let height = collectionView.frame.height
        let width = self.view.frame.width
        let itemSize : CGSize = CGSize(width: width, height: height)
        collectionViewFlowLayout.itemSize = itemSize
    }
}

extension InitialViewController : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = self.collectionView.contentOffset.x/self.view.frame.width
        pageControl.currentPage = Int(currentIndex)
        
        if currentIndex == 2{
            UIView.animate(withDuration: 2.0, animations: {
                self.pageControl.isHidden = true
                self.getStartedButton.isHidden = false
            })
        } else {
            pageControl.isHidden = false
            getStartedButton.isHidden = true
        }
    }
}

extension InitialViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "initialCell", for: indexPath) as! InitialCollectionViewCell
        cell.setupCollectionViewCell(image: InitialViewStruct.imageArray[indexPath.item], title: InitialViewStruct.titleArray[indexPath.item], description: InitialViewStruct.descriptionArray[indexPath.item])
        
        return cell
    }
}

