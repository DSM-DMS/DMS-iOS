//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ApplyStayVC: UIViewController  {

    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satComSwitch: UISwitch!
    @IBOutlet weak var satOutSwitch: UISwitch!
    @IBOutlet weak var staySwitch: UISwitch!
    
    private var selectId = -1
    private var switchArr = [UISwitch]()
    private let disposeBag = DisposeBag()
    
    @IBAction func back(_ sender: Any){
        goBack()
    }
    
    override func viewDidLoad(){
        switchArr = [friSwitch, satComSwitch, satOutSwitch, staySwitch]
    }
    
    override func viewWillAppear(_ animated: Bool){
         setBind()
    }

    @IBAction func apply(_ sender: UIButton){
        if selectId == -1{ showToast(msg: "잔류상태를 선택하세요"); return }
        Connector.instance.request(createRequest(sub: "/stay", method: .post, params: ["value" : "\(selectId + 1)"]), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                switch code{
                case 201: self.showToast(msg: "신청 성공", fun: self.goBack)
                case 204: self.showToast(msg: "신청 시간이 아닙니다")
                default: self.showError(code)
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func stateChange(_ sender: UISwitch){
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
    
    func setBind(){
        Connector.instance.request(createRequest(sub: "/stay", method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{ let value = try! JSONDecoder().decode(StayModel.self, from: data).value
                    self.stateChange(self.switchArr[value - 1])
                }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
}
