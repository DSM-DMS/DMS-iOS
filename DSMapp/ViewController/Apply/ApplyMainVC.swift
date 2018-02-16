//
//  ApplyMainVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 7..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ApplyMainVC: UIViewController{
    
    @IBOutlet weak var applyStudyBar: UIView!
    @IBOutlet weak var applyStayBar: UIView!
    @IBOutlet weak var applyOutBar: UIView!
    @IBOutlet weak var surveyBar: UIView!
    
    @IBOutlet weak var applyStudyButton: ButtonShape!
    @IBOutlet weak var applyStayButton: ButtonShape!
    @IBOutlet weak var applyOutButton: ButtonShape!
    @IBOutlet weak var surveyButton: ButtonShape!
    
    @IBOutlet weak var applyStudyLabel: UILabel!
    @IBOutlet weak var applyStayLabel: UILabel!
    @IBOutlet weak var applyOutSatSwitch: UISwitch!
    @IBOutlet weak var applyOutSunSwitch: UISwitch!
    
    @IBOutlet weak var surveyHeight: NSLayoutConstraint!
    @IBOutlet weak var applyOutHeight: NSLayoutConstraint!
    @IBOutlet weak var applyStayHeight: NSLayoutConstraint!
    @IBOutlet weak var applyStudyHeight: NSLayoutConstraint!
    
    var buttonArr: [UIButton]!
    var currentUpId = -1
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentUpId == -1{ UIView.animate(withDuration: 0.3){ self.setBarUpDown(0, up: false) }; currentUpId = 0 }
    }
    
    private func goApplyView(_ id: Int){
        if Token.instance.get().isEmpty{ showToast(msg: "로그인이 필요합니다"); return }
        if id == 3{
            goNextViewWithStoryboard(storyId: "Survey", id: "SurveyListView")
            return
        }
        let vcIdArr = ["ApplyStudyView", "ApplyStayView", "", "SurveyView"]
        goNextViewController(vcIdArr[id])
    }
    
    private func applyOut(){
        if Token.instance.get().isEmpty{ showToast(msg: "로그인이 필요합니다"); return }
        Connector.instance.request(createRequest(sub: "/goingout", method: .post, params: getOutParam()), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                if code == 201{ self.showToast(msg: "신청 성공") }else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func loadData(){
        Connector.instance.request(createRequest(sub: "/mypage", method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    let data = try! JSONDecoder().decode(MyPageModel.self, from: data)
                    self.bind(data: data)
                }else{
                    self.showError(code)
                }
            }).disposed(by: disposeBag)
    }

}

extension ApplyMainVC{
    
    private func setInit(){
        buttonArr = [applyStudyButton, applyStayButton, applyOutButton, surveyButton]
        applyStudyBar.backgroundColor = Color.CO4.getColor()
        applyStayBar.backgroundColor = Color.CO3.getColor()
        applyOutBar.backgroundColor = Color.CO2.getColor()
        surveyBar.backgroundColor = Color.CO1.getColor()
        for buttonId in 0...3{ setButton(id: buttonId) }
    }
    
    private func bind(data: MyPageModel){
        applyStudyLabel.text = data.getStudyState()
        applyStayLabel.text = "상태 : " + data.getStayState()
        applyOutSatSwitch.isOn = data.goingout.sat
        applyOutSunSwitch.isOn = data.goingout.sun
    }
    
    private func setButton(id: Int){
        buttonArr[id].rx.controlEvent(.touchUpInside)
            .asObservable().subscribe(onNext: { [unowned self]  _ in
                if id == self.currentUpId{ if id == 2{ self.applyOut() }else{ self.goApplyView(id) } }
                else{
                    UIView.animate(withDuration: 0.3){
                        self.setBarUpDown(self.currentUpId, up: true)
                        self.setBarUpDown(id, up: false)
                    }}
                self.currentUpId = id
            }).disposed(by: disposeBag)
    }
    
    private func setBarUpDown(_ id: Int, up: Bool){
        let heightArr: [NSLayoutConstraint] = [applyStudyHeight, applyStayHeight, applyOutHeight, surveyHeight]
        heightArr[id].constant += up ? -123 : 123
        buttonArr[id].setTitle(up ? "열기" : "신청", for: .normal)
        view.layoutIfNeeded()
    }
    
    private func getOutParam() -> [String : String]{
        var param = [String : String]()
        param["sat"] = applyOutSatSwitch.isOn.description
        param["sun"] = applyOutSunSwitch.isOn.description
        return param
    }
    
}

