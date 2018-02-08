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
    
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewFlowLayout()
        getStartedButton.isHidden = true
        collectionView.backgroundColor = colors.clearColor
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = colors.whiteColor
    }
    
    func setupCollectionViewFlowLayout(){
        let spacing : CGFloat = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = spacing
        collectionViewFlowLayout.minimumLineSpacing = spacing
        var height : CGFloat
        if self.view.frame.height < 600 {
            //for iphone 5s and SE
            height = collectionView.frame.height - 120
        } else {
            //for other iphones
             height = collectionView.frame.height
        }
        let width = self.view.frame.width
        let itemSize : CGSize = CGSize(width: width, height: height)
        collectionViewFlowLayout.itemSize = itemSize
    }
    
    func hideButton(bool : Bool , button : UIButton){
        button.isUserInteractionEnabled = !bool
        button.isHidden = bool
    }
    
    @IBAction func leftButtonPressed(){
        let indexPath = IndexPath(item: currentIndex - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    @IBAction func rightButtonPressed(){
        let indexPath = IndexPath(item: currentIndex + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
}

extension InitialViewController : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(self.collectionView.contentOffset.x/self.view.frame.width)
        pageControl.currentPage = Int(currentIndex)
        
        if currentIndex < 2 {
            getStartedButton.isHidden = true
            pageControl.isHidden = false
        } else {
            let height = UIScreen.main.bounds.height

            self.getStartedButton.frame.origin.y = height - 40
            
            UIView.animate(withDuration: 0.2, animations: {
                self.getStartedButton.frame.origin.y = height - 60
            }, completion: { _ in
                self.getStartedButton.frame.origin.y = height - 60
            })
            getStartedButton.isHidden = false
            pageControl.isHidden = true
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

