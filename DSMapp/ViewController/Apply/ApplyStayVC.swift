//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ApplyStayVC: UIViewController  {

    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satComSwitch: UISwitch!
    @IBOutlet weak var satOutSwitch: UISwitch!
    @IBOutlet weak var staySwitch: UISwitch!
    
    var selectId = -1
    var switchArr = [UISwitch]()
    
    @IBAction func pressBack(_ sender: Any) {
        back()
    }
    
    override func viewDidLoad() {
        switchArr = [friSwitch, satComSwitch, satOutSwitch, staySwitch]
    }
    
    override func viewWillAppear(_ animated: Bool) {
         bind()
    }

    @IBAction func apply(_ sender: UIButton) {
        if selectId > -1{
            connector(add: "/stay", method: "POST", params: ["value" : "\(selectId + 1)"], fun: {
                _, code in
                switch code{
                case 201:
                    self.showToast(msg: "신청성공", fun: self.back)
                case 204:
                    self.showToast(msg: "신청 시간이 아닙니다")
                default:
                    self.showToast(msg: "오류 : \(code)")
                }
            })
        }else{
            showToast(msg: "잔류상태를 선택하세요.")
        }
        
    }
    
    @IBAction func stateChange(_ sender: UISwitch) {
        let id = getSelectSwitchId(sender)
        print(id)
        if selectId > -1{
            if sender.isOn{
                switchArr[selectId].setOn(false, animated: true)
            }else{
                if id == 3{
                    selectId = -1
                    return
                }else{
                    staySwitch.setOn(true, animated: true)
                    selectId = 3
                    return
                }
            }
        }else{
            switchArr[id].setOn(true, animated: true)
        }
        
        selectId = id
    }
    
}

extension ApplyStayVC{
    
    func getSelectSwitchId(_ sender: UISwitch) -> Int{
        for i in 0..<switchArr.count{
            if switchArr[i] == sender{
                return i
            }
        }
        return 0
    }
    
    func bind(){
        connector(add: "/stay", method: "GET", params: [:], fun: {
            data, code in
            if code == 200{
                let state = try! JSONDecoder().decode(StayModel.self, from: data!)
                self.stateChange(self.switchArr[state.value - 1])
            }else{
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }
    
}
