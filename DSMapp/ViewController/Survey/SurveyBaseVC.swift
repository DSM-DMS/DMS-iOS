//
//  SurveyBaseVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 13..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyBaseVC: UIViewController {

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var backView: BackViewShape!
    @IBOutlet weak var titleLabel: UILabel!
    let pageVC = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var id = ""
    var dataArr = [SurveyModel]()
    
    
    override func viewDidLoad() {
        
        bind()
        pageVC.dataSource = self
        
        connector(add: "/survey/\(id)", method: "GET", params: [:], fun: {
            data, code in
            if code == 200{
                self.dataArr = try! JSONDecoder().decode(Array<SurveyModel>.self, from: data!)
                self.pageVC.setViewControllers([self.getContentView(0)!], direction: .forward, animated: true, completion: nil)
            }else{
                self.showToast(msg: "오류 : \(code)")
            }
        })
        
    }

}

extension SurveyBaseVC: UIPageViewControllerDataSource{
    
    func bind(){
        pageVC.view.frame = CGRect.init(x: 2, y: 2, width: backView.frame.size.width - 4, height: backView.frame.size.height - 4)
        pageVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pageVC.dataSource = self
        backView.addSubview(pageVC.view)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let view = viewController as! SurveyContentVC
        return getContentView(view.count - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let view = viewController as! SurveyContentVC
        return getContentView(view.count + 1)
    }
    
    func getContentView(_ count: Int) -> SurveyContentVC?{
        if count < dataArr.count{
            var vc: SurveyContentVC
            if dataArr[count].is_objective{
                vc = storyboard?.instantiateViewController(withIdentifier: "SurveyObView") as! SurveyObVC
            }else{
                vc = storyboard?.instantiateViewController(withIdentifier: "SurveyNObView") as! SurveyNObVC
            }
            
            vc.id = dataArr[count].id
            vc.titleText = dataArr[count].title
            vc.count = count
            
            return vc
        }else{
            return nil
        }
    }
    
}
