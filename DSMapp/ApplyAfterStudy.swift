//
//  applyAfterStudy.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit


class ApplyAfterStudy: UIViewController, UIPageViewControllerDataSource  {
    
    @IBOutlet weak var finishDateLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentCountView: UIView!
    
    @IBOutlet weak var sendItem: UIBarButtonItem!
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func send(_ sender: Any) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(currentIndex)
        if currentIndex >= tempData.count - 1{
            return nil
        }
        currentIndex += 1
        return getContentVieWControllerAtIndex(index: currentIndex, data: tempData[currentIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(currentIndex)
        
        if(currentIndex == 0){
            return nil
        }
        currentIndex -= 1
        return getContentVieWControllerAtIndex(index: currentIndex, data: tempData[currentIndex])
    }
    
    var currentIndex = 0
    
    var pageViewController : UIPageViewController!
    
    let tempData = [["월요일" : ["배드민턴","피구","농구","발야구"]],
                    ["화요일" : ["요가","댄스","헬스","C언어"]],
                    ["토요일" : ["자전거","배구","축구","자습"]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageViewController") as! UIPageViewController
        pageViewController.view.frame = CGRect.init(x: 4, y: 0, width: self.contentView.frame.width - 8, height: self.contentView.frame.height)
        pageViewController.dataSource = self
        setPageViewController()
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        contentView.layer.cornerRadius = 4
        let designView = UIView.init(frame: CGRect.init(x: contentView.frame.minX - 4, y: contentView.frame.minY + 16, width: 4, height: 52))
        designView.backgroundColor = getDarkBlueColor()
        self.view.addSubview(designView)
        self.contentView.addSubview(pageViewController.view)
        setCountContentView()
    }
    
    func setPageViewController(){
        pageViewController.setViewControllers([getContentVieWControllerAtIndex(index: currentIndex, data: tempData[currentIndex])!], direction: .forward, animated: true, completion: nil)
    }
    
    func setCountContentView(){
        var currentX = contentCountView.frame.width / 2
        currentX -= CGFloat(12 * Double((tempData.count - 1)) + 8)
        for i in 0..<tempData.count {
            let check = (i == 0)
            contentCountView.addSubview(getCircleView(currentX, select: check))
            currentX += 24
        }
    }
    
    func changeContentCount(_ selectNum : Int){
        let countViews = contentCountView.subviews
        
        if countViews.count == 0{
            return
        }
        
        (countViews[selectNum] as! UIImageView).image = UIImage.init(named: "selectCountCircle")
        
        if(selectNum - 1 > -1){
            (countViews[selectNum - 1] as! UIImageView).image = UIImage.init(named: "unSelectCountCircle")
        }
        if(selectNum + 1 < countViews.count){
            (countViews[selectNum + 1] as! UIImageView).image = UIImage.init(named: "unSelectCountCircle")
        }
    }
    
    
    func getCircleView(_ x : CGFloat, select : Bool) -> UIView{
        let tempView = UIImageView.init(frame: CGRect.init(x: x, y: 5, width: 16, height: 16))
        tempView.layer.cornerRadius = 10
        if select{
            tempView.image = UIImage.init(named: "selectCountCircle")
        }else{
            tempView.image = UIImage.init(named: "unselectCountCircle")
        }
        return tempView
    }

    
    func getContentVieWControllerAtIndex(index : Int, data : [String : [String]]) -> ApplyAfterContent? {
        
        if index >= tempData.count || index < 0{
            return nil
        }
        
        changeContentCount(index)
        
        let currentContentView = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! ApplyAfterContent
        currentContentView.name = data.keys.first!
        currentContentView.data = data.values.first!
        
        return currentContentView
    }

}
