//
//  ApplyMainVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 7..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

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
    
    var buttonArr = [UIButton]()
    var barArr = [UIView]()
    var heightArr = [NSLayoutConstraint]()
    var currentUpId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonArr = [applyStudyButton, applyStayButton, applyOutButton, surveyButton]
        barArr = [applyStudyBar, applyStayBar, applyOutBar, surveyBar]
        heightArr = [applyStudyHeight, applyStayHeight, applyOutHeight, surveyHeight]
        
        applyStudyBar.backgroundColor = Color.CO4.getColor()
        applyStayBar.backgroundColor = Color.CO3.getColor()
        applyOutBar.backgroundColor = Color.CO2.getColor()
        surveyBar.backgroundColor = Color.CO1.getColor()
        
        for button in buttonArr{
            button.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        }
        
        addAction(applyStudyButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @objc func addAction(_ button: UIButton){
        let id = getIdToButton(button)

        UIView.animate(withDuration: 0.3, animations: {
            if id == self.currentUpId{
                if id == 2{
                    self.applyOut()
                }else{
                    self.goApplyView(id)
                }
            }else{
                if self.currentUpId > -1{
                    self.heightArr[self.currentUpId].constant -= 123
                    self.buttonArr[self.currentUpId].setTitle("열기", for: .normal)
                }
                self.heightArr[id].constant += 123
                self.buttonArr[id].setTitle("신청", for: .normal)
                self.view.layoutIfNeeded()
            }
        })
        
        currentUpId = id
    }
    
    func goApplyView(_ idNum: Int){
        if getToken() != nil{
            if idNum == 3{
                goNextViewWithStoryboard(storyId: "Survey", id: "SurveyInfoView")
                return
            }
            let vcIdArr = ["ApplyStudyView", "ApplyStayView", "", "SurveyView"]
            goNextViewController(vcIdArr[idNum])
        }else{
            showToast(msg: "로그인을 하세요.")
        }
    }
    
    func applyOut(){
        if getToken() != nil{
            connector(add: "/goingout", method: "POST", params: ["sat":"\(applyOutSatSwitch.isOn)", "sun":"\(applyOutSunSwitch.isOn)"], fun: {
                _, code in
                if code == 201{
                    self.showToast(msg: "신청 성공")
                }else{
                    self.showToast(msg: "신청 실패 : \(code)")
                }
            })
        }else{
            showToast(msg: "로그인을 하세요.")
        }
    }
    
    func getIdToButton(_ button: UIButton) -> Int{
        for i in 0..<buttonArr.count{
            if buttonArr[i] == button{
                return i
            }
        }
        return 0
    }
    
    func loadData(){
        connector(add: "/mypage", method: "GET", params: [:], fun: {
            data, code in
            
            switch code {
            case 200:
                let decoderData = try! JSONDecoder().decode(MyPageModel.self, from: data!)
                
                self.applyStudyLabel.text = decoderData.getStudyState()
                self.applyStayLabel.text = "신청 : \(self.getStayStateName(decoderData.stay_value))"
                self.applyOutSatSwitch.setOn(decoderData.goingout_sat, animated: true)
                self.applyOutSunSwitch.setOn(decoderData.goingout_sun, animated: true)
                
            case 204, 401:
                self.showToast(msg: "로그인이 필요합니다.")
            default:
                self.showToast(msg: "오류 : \(code)")
            }
            
        })
    }

}
