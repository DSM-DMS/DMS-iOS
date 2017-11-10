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
        
        applyStudyBar.backgroundColor = Color.CO5.getColor()
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
    
    func addAction(_ button: UIButton){
        let id = getIdToButton(button)

        UIView.animate(withDuration: 0.3, animations: {
            if id == self.currentUpId{
                
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
                
                if decoderData.extension_class == nil{
                    self.applyStudyLabel.text = "신청하지 않습니다."
                }else{
                    self.applyStudyLabel.text = "신청: \(self.getClassName(decoderData.extension_class!))-\(decoderData.extension_seat!)"
                }
                self.applyStayLabel.text = "신청: \(self.getStayStateName(decoderData.stay_value))"
                self.applyOutSatSwitch.setOn(decoderData.goingout_sat, animated: true)
                self.applyOutSunSwitch.setOn(decoderData.goingout_sun, animated: true)
                
            case 204:
                self.showToast(msg: "로그인이 필요합니다.")
            default:
                self.showToast(msg: "오류가 발생했습니다. : \(code)")
            }
            
        })
    }
    
    func goApply(){
        
    }

}

extension ApplyMainVC{
    
}
