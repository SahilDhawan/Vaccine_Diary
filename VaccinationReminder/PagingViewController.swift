//
//  PagingViewController.swift
//  Vaccine_Diary
//
//  Created by Sahil Dhawan on 28/11/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class PagingViewController: UIPageViewController {
    
    var viewControllersArray : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.dataSource = self
        for i in 0..<7 {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialPageViewController") as! InitialPageViewController
            let imageName = "vaccine \(i+1)"
            viewController.image = UIImage(named: imageName)
            viewController.currentPage = i
            viewControllersArray.append(viewController)
        }
        
        if let firstViewController = viewControllersArray.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}

extension PagingViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = viewControllersArray.count
        guard viewControllersCount != nextIndex else {
            return nil
        }
        guard viewControllersCount > nextIndex else {
            return nil
        }
        return viewControllersArray[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard viewControllersArray.count > previousIndex else {
            return nil
        }
        return viewControllersArray[previousIndex]
    }
}

