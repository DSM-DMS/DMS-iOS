//
//  MealViewController.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift

class MealVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    private var date: Date!
    private let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let aDay = TimeInterval(86400)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        date = Date()
        pageViewSetUp()
    }
    
}

extension MealVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    private func pageViewSetUp(){
        pageViewController.dataSource = self
        let contentView = UIView(frame: CGRect(x: 16, y: 32, width: backView.frame.size.width - 32, height: backView.frame.size.height - 64))
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = UIColor.white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        pageViewController.view.frame = CGRect(x: 2, y: 2, width: contentView.frame.width - 4, height: contentView.frame.height - 4)
        contentView.addSubview(pageViewController.view)
        backView.addSubview(contentView)
        pageViewController.setViewControllers([getViewController(date)!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        let beforeViewController = viewController as! MealContentVC
        return getViewController(beforeViewController.date, next: false)
    }
    
    func getViewController(_ date: Date, next: Bool? = nil) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MealContentView") as! MealContentVC
        if date <= self.date && next == false{ return nil }
        if let next = next{ viewController.date = date + (next ? aDay : -aDay) }
        else{ viewController.date = date }
        return viewController
    }
    
}
