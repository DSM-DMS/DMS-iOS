//
//  MealViewController.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MealVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    var aDay = TimeInterval(86400)
    
    override func viewDidLoad() {
        pageViewSetUp(pageViewController.view)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([getViewController(Date(), next: nil)], direction: .forward, animated: true, completion: nil)
    }
    
}

extension MealVC: UIPageViewControllerDataSource{
    
    func pageViewSetUp(_ contentView: UIView){
        
        let tempView = UIView.init(frame: CGRect(x: 16, y: 32, width: backView.frame.size.width - 32, height: backView.frame.size.height - (64)))
        tempView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.frame = CGRect(x: 2, y: 2, width: tempView.frame.size.width - 4, height: tempView.frame.size.height - 4)
        tempView.layer.cornerRadius = 8
        tempView.backgroundColor = UIColor.white
        tempView.layer.shadowColor = UIColor.black.cgColor
        tempView.layer.shadowOpacity = 0.3
        tempView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        tempView.addSubview(contentView)
        backView.addSubview(tempView)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: false)
    }
    
    func getViewController(_ date: Date?, next: Bool?) -> UIViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MealContentView") as! MealContentVC
        if next == nil{
            viewController.date = date
        }else if next!{
            viewController.date = date! + self.aDay
        }else{
            viewController.date = date! - self.aDay
        }
        return viewController
    }
    
}
