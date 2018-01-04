//
//  SurveyPageVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyPageVC: UIViewController {
    
    var contentList = Array<SurveyModel>()
    var contentPosition = 0
    let tempArr = [true, false, true, false]
    
    let pageVC = UIPageViewController()
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageVC.view.frame.size = contentView.frame.size
        pageVC.setViewControllers([getContentView(tempArr[contentPosition])], direction: .forward, animated: true, completion: nil)
        contentView.addSubview(pageVC.view)
    }
    
    func setContentView(){
        if contentPosition == tempArr.count - 1{
            showToast(msg: "설문조사 완료", fun: { self.dismiss(animated: true, completion: nil) })
        }else{
            contentPosition += 1
            pageVC.setViewControllers([getContentView(tempArr[contentPosition])], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func getContentView(_ is_objective: Bool) -> UIViewController{
        if is_objective{
            let VC = storyboard?.instantiateViewController(withIdentifier: "SurveyObView") as! SurveyObVC
            VC.nextFunc = setContentView
            return VC
        }else{
            let VC = storyboard?.instantiateViewController(withIdentifier: "SurveyNObView") as! SurveyNObVC
            VC.nextFunc = setContentView
            return VC
        }
    }

}
