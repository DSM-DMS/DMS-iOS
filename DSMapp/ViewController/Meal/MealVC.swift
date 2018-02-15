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
    
    private var date: Date!
    private let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let aDay = TimeInterval(86400)
    
    override func viewDidLoad() {
        date = Date()
        pageViewSetUp()
    }
    
}

extension MealVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    private func pageViewSetUp(){
        pageViewController.dataSource = self
        pageViewController.view.bounds = backView.bounds
        backView.addSubview(pageViewController.view)
        pageViewController.setViewControllers([getViewController(date)!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: false)
    }
    
    func getViewController(_ date: Date, next: Bool? = nil) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MealContentView") as! MealContentVC
        let contentView = viewController.view
        contentView?.frame = CGRect(x: 16, y: 32, width: backView.frame.size.width - 32, height: backView.frame.size.height - 64)
        contentView?.layer.cornerRadius = 8
        if date <= self.date && next != nil{ return nil }
        if let next = next{ viewController.date = date + (next ? aDay : -aDay) }
        else{ viewController.date = date }
        return viewController
    }
    
}
