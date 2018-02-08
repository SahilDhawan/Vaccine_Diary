//
//  InitialViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 31/12/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var getStartedButton : UIButton!
    @IBOutlet weak var collectionViewFlowLayout : UICollectionViewFlowLayout!
    
    var currentIndex : Int = 0
    
    //MARK: View related functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewFlowLayout()
        getStartedButton.isHidden = true
        collectionView.backgroundColor = colors.clearColor
        UIApplication.shared.statusBarStyle = .default
    }
    
    //setting the collection view
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = colors.whiteColor
    }
    
    // setting the collection view size usig collection view flow layout
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
    
    // hiding button
    func hideButton(bool : Bool , button : UIButton){
        button.isUserInteractionEnabled = !bool
        button.isHidden = bool
    }
}

//MARK: UICollectionViewDelegate
extension InitialViewController : UICollectionViewDelegate {
    
    // updating the page Control according to collection view scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(self.collectionView.contentOffset.x/self.view.frame.width)
        pageControl.currentPage = Int(currentIndex)
        
        if currentIndex < 2 {
            getStartedButton.isHidden = true
            pageControl.isHidden = false
        } else {
            let height = UIScreen.main.bounds.height
            self.getStartedButton.frame.origin.y = height - 40
            
            //animating get started button
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

//MARK: UICollectionViewDataSource
extension InitialViewController : UICollectionViewDataSource {
    
    //setting the number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // setting up collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "initialCell", for: indexPath) as! InitialCollectionViewCell
        cell.setupCollectionViewCell(image: InitialViewStruct.imageArray[indexPath.item], title: InitialViewStruct.titleArray[indexPath.item], description: InitialViewStruct.descriptionArray[indexPath.item])
        
        return cell
    }
}

