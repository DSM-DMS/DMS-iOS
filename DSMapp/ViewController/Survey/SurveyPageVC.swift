//
//  SurveyPageVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift

class SurveyPageVC: UIPageViewController {
    
    var contentList = Array<SurveyModel>()
    var position = 0
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([getContentView()], direction: .forward, animated: true, completion: nil)
    }
    
    func sendAnswer(_ id: String, answer: String, fun: (() -> ())?){
        Connector.instance.request(createRequest(sub: "/survey/question", method: .post, params: ["question_id" : id, "answer" : answer]), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                if code == 201{ self.showToast(msg: "답변을 남겼습니다", fun: fun) }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    func nextFunc(_ answer: String){
        if position == contentList.count - 1{
            sendAnswer(contentList[position].id, answer: answer, fun: self.goBack)
        }else{
            sendAnswer(contentList[position].id, answer: answer, fun: {
                self.position += 1
                self.setViewControllers([self.getContentView()], direction: .forward, animated: true, completion: nil)
            })
        }
    }
    
    func getContentView() -> UIViewController{
        let currentData = contentList[position]
        let questionTitle = currentData.title
        let isObject = currentData.is_objective
        let answerArr = currentData.choice_paper
        if isObject{
            let VC = storyboard?.instantiateViewController(withIdentifier: "SurveyObView") as! SurveyObVC
            VC.questionTitle = questionTitle
            VC.answerArr = answerArr!
            VC.nextFunc = nextFunc
            return VC
        }else{
            let VC = storyboard?.instantiateViewController(withIdentifier: "SurveyNObView") as! SurveyNObVC
            VC.questionTitle = questionTitle
            VC.nextFunc = nextFunc
            return VC
        }
    }
    
}
