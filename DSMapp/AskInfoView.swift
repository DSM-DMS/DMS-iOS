//
//  AskInfoView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 9. 18..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class AskInfoView: UIViewController, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getContentViewControllerAtIndex(index: 1, isEdit: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getContentViewControllerAtIndex(index: 1, isEdit: false)
    }
    

    @IBOutlet var contentView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bottomView: UIView!
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "askInfoPageViewController") as! UIPageViewController
        pageViewController.view.frame = CGRect.init(x: 4, y: 0, width: self.contentView.frame.width - 8, height: self.contentView.frame.height)
        pageViewController.dataSource = self
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        contentView.layer.cornerRadius = 4
        setPageViewController()
        contentView.addSubview(pageViewController.view)
    }
    
    func setPageViewController(){
    pageViewController.setViewControllers([getContentViewControllerAtIndex(index: 0, isEdit: true)!], direction: .forward, animated: true, completion: nil)
    }
    
    func getContentViewControllerAtIndex(index : Int, isEdit : Bool) -> UIViewController?{
        
        
        let currenContentView = self.storyboard?
            .instantiateViewController(withIdentifier: isEdit ? "AskInfoContentEditView" : "AskInfoContentSelectView")
//        if isEdit{
//            (currenContentView as! AskInfoContentEditView)
//        }else{
//            (currenContentView as! AskInfoContentSelectView)
//        }
        
        return currenContentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    

}
