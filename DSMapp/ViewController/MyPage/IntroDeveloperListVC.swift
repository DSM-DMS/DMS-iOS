//
//  IntroDeveloperVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 28..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class IntroDeveloperListVC: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setViewControllers([getContentVC(position: 0)!], direction: .forward, animated: true, completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! IntroDeveloperContentVC
        return getContentVC(position: contentVC.position + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! IntroDeveloperContentVC
        return getContentVC(position: contentVC.position - 1)
    }
    
    func getContentVC(position: Int) -> IntroDeveloperContentVC? {
        if position < 0 || position > 4 { return nil }
        print(position)
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "IntroDeveloperContentView") as! IntroDeveloperContentVC
        return contentVC.setPosition(position)
    }
    
}
