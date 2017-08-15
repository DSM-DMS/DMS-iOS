//
//  applyAfterStudy.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit


class applyAfterStudy: UIViewController, UIPageViewControllerDataSource  {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! applyAfterContent).contentIndex
        
        print("hello world")
        
        return getContentVieWControllerAtIndex(index: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! applyAfterContent).contentIndex
        
        if(index == 0){
            return nil
        }
        
        return getContentVieWControllerAtIndex(index: index - 1)
    }
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageViewController") as! UIPageViewController
        
        pageViewController.view.frame = CGRect.init(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.height)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([getContentVieWControllerAtIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
        
        self.view.addSubview(pageViewController.view)
    }

    func getContentVieWControllerAtIndex(index : Int) -> applyAfterContent? {
        if index >= 3{
            return nil
        }
        let currentContentView = applyAfterContent();
        currentContentView.contentIndex = index
        currentContentView.changeBack()
        
        return currentContentView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
