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
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentCountView: UIView!
    
    
    @IBAction func sendData(_ sender: Any) {
        if currentIndex == tempData.count-1{
            //제출해야지
        }else{
            currentIndex += 1
            setPageViewController()
        }
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        let alert = UIAlertController.init(title: "상세정보", message: nil, preferredStyle: .alert)
        alert.message = "안녕하세요 소라입니다 이곳에 듣고 싶은 텍스트를 입력해주세요 아시겠습니까? 넵 알겠습니다.!!!! 뭔소린지 잘 모르시겠어도 그냥 네하고 들으세요 아시겠습니까? 넵 겠습니다. 그렇다면 게임 스타트"
        alert.addAction(UIAlertAction.init(title: "확인", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex <= tempData.count{
            return nil
        }
        currentIndex += 1
        return getContentVieWControllerAtIndex(index: currentIndex, data: tempData[currentIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
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
        navigationController?.navigationBar.barTintColor = UIColor.white
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageViewController") as! UIPageViewController
        pageViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        pageViewController.dataSource = self
        setPageViewController()
        self.contentView.addSubview(pageViewController.view)
        setCountContentView()
    }
    
    func setPageViewController(){
        pageViewController.setViewControllers([getContentVieWControllerAtIndex(index: currentIndex, data: tempData[currentIndex])!], direction: .forward, animated: true, completion: nil)
    }
    
    func setCountContentView(){
        var currentX = contentCountView.frame.width / 2
        currentX -= CGFloat(12.5 * Double((tempData.count - 1)) + 10)
        for i in 0..<tempData.count {
            let check = (i == 0)
            contentCountView.addSubview(getCircleView(currentX, select: check))
            currentX += 25
        }
    }
    
    func changeContentCount(_ selectNum : Int){
        let countViews = contentCountView.subviews
        
        if countViews.count == 0{
            return
        }
        
        countViews[selectNum].backgroundColor = UIColor.init(red: 68/255, green: 138/255, blue: 1, alpha: 1)
        
        if(selectNum - 1 > -1){
            countViews[selectNum - 1].backgroundColor = UIColor.init(red: 187/255, green: 222/255, blue: 251/255, alpha: 1)
        }
        if(selectNum + 1 < countViews.count){
            countViews[selectNum + 1].backgroundColor = UIColor.init(red: 187/255, green: 222/255, blue: 251/255, alpha: 1)
        }
    }
    
    
    func getCircleView(_ x : CGFloat, select : Bool) -> UIView{
        let tempView = UIView.init(frame: CGRect.init(x: x, y: 5, width: 20, height: 20))
        tempView.layer.cornerRadius = 10
        if select{
            tempView.backgroundColor = UIColor.init(red: 68/255, green: 138/255, blue: 1, alpha: 1)
        }else{
            tempView.backgroundColor = UIColor.init(red: 187/255, green: 222/255, blue: 251/255, alpha: 1)
        }
        return tempView
    }

    
    func getContentVieWControllerAtIndex(index : Int, data : [String : [String]]) -> ApplyAfterContent? {
        
        if index >= tempData.count || index < 0{
            return nil
        }
        
        if(index == tempData.count-1){
            sendButton.setTitle("제출하기", for: .normal)
        }else{
            sendButton.setTitle("다음 문항", for: .normal)
        }
        
        changeContentCount(index)
        
        let currentContentView = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! ApplyAfterContent
        currentContentView.name = data.keys.first!
        currentContentView.data = data.values.first!
        
        return currentContentView
    }

}
