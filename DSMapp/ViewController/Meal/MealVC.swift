//
//  MealViewController.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MealVC: UIViewController {
    
    let pageViewController = UIPageViewController()
    
    override func viewDidLoad() {
        pageViewSetUp(pageViewController.view)
        pageViewController.dataSource = self
        
    }
}

extension MealVC: UIPageViewControllerDataSource{
    
    func pageViewSetUp(_ contentView: UIView){
        contentView.frame = CGRect(x: 32, y: 48, width: self.view.frame.size.width - 64, height: view.frame.size.height - (64 + 48))
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        contentView.layer.shadowOpacity = 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
}
