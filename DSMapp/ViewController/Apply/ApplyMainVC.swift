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
    
    private let disposeBag = DisposeBag()
    
    private let vcIdArr =
        ["ApplyStudyView", "ApplyStayView", "", ""]
    
    private var buttonArr: [UIButton]!
    private var currentUpId = -1
    
    override func viewDidLoad() {
        setInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentUpId == -1{
            currentUpId = 0
            UIView.animate(withDuration: 0.3){ self.setBarUpDown(0, up: false) }
        }
    }
    
    private func goApplyView(_ id: Int){
        if id == 3 { showTempAlert(); return }
        if loginCheck() { goNextViewController(vcIdArr[id]) }
    }
    
    private func applyOut(){
        if loginCheck() {
            _ = Connector.instance
                .getRequest(ApplyAPI.applyOrGetGoingOutInfo, method: .post, params: getOutParam())
                .emptyData(vc: self)
                .subscribe(onNext: { [weak self] code in
                    guard let strongSelf = self else { return }
                    if code == 201{ strongSelf.showToast(msg: "신청 성공") }
                    else if code == 204{ strongSelf.showToast(msg: "신청 시간이 아닙니다.") }
                    else{ strongSelf.showError(code) }
                })
        }
    }
    
    private func loadData(){
        if !loginCheck() { return }
        _ = Connector.instance
                .getRequest(InfoAPI.getApplyInfo, method: .get)
                .decodeData(ApplyModel.self, vc: self)
                .subscribe(onNext: { [weak self] code, data in
                    guard let strongSelf = self else { return }
                    if code == 200{ strongSelf.bind(data: data!) }
                    else{ strongSelf.showError(code) }
                })
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
    
    private func bind(data: ApplyModel){
        applyStudyLabel.text = data.getStudyState()
        applyStayLabel.text = "상태 : " + data.getStayState()
        applyOutSatSwitch.isOn = data.goingout.sat
        applyOutSunSwitch.isOn = data.goingout.sun
    }
    
    private func setButton(id: Int){
        buttonArr[id].rx.controlEvent(.touchUpInside)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                if id == self.currentUpId{ id == 2 ? self.applyOut() : self.goApplyView(id)  }
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
    
    private func getOutParam() -> [String : Bool]{
        var param = [String : Bool]()
        param["sat"] = applyOutSatSwitch.isOn
        param["sun"] = applyOutSunSwitch.isOn
        return param
    }
    
    private func showTempAlert(){
        let alertMessage = """
            DMS 페이스북 메신저를 통해 알려주세요.
            DMS가 의견을 참고하여 개발하겠습니다.
            감사합니다.
        """
        let alert = UIAlertController(title: "당신이 원하는 DMS의 새로운 기능", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}

