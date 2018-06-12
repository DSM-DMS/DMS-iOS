//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ApplyStayVC: UIViewController  {

    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satComSwitch: UISwitch!
    @IBOutlet weak var satOutSwitch: UISwitch!
    @IBOutlet weak var staySwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    
    private var selectedSwitch: UISwitch?
    private var selectedId = 0
    private var switchArr: [UISwitch]!
    
    @IBAction func back(_ sender: Any){
        goBack()
    }
    
    override func viewDidLoad(){
        setInit()
    }
    
    override func viewWillAppear(_ animated: Bool){
         setBind()
    }

    @IBAction func apply(_ sender: UIButton){
        if selectedId == 0{ showToast(msg: "잔류상태를 선택하세요"); return }
        _ = Connector.instance
            .getRequest(ApplyAPI.applyOrGetStayInfo, method: .post, params: ["value" : "\(selectedId + 1)"])
            .emptyData(vc: self)
            .subscribe(onNext: { [weak self] code in
                guard let strongSelf = self else { return }
                switch code{
                case 201: strongSelf.showToast(msg: "신청 성공", fun: strongSelf.goBack)
                case 204: strongSelf.showToast(msg: "신청 시간이 아닙니다")
                default: strongSelf.showError(code)
                }
            })
    }
    
}

extension ApplyStayVC{
    
    private func setInit(){
        switchArr = [friSwitch, satComSwitch, satOutSwitch, staySwitch]
        for id in 0..<switchArr.count{ setSwitch(id) }
    }
    
    private func setSwitch(_ id: Int){
        let sw = switchArr[id]
        sw.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] _ in self.valueChange(id, value: sw.isOn) })
            .disposed(by: disposeBag)
    }
    
    private func valueChange(_ id: Int, value: Bool){
        if id == 3 && !value{ selectedId = 0; selectedSwitch = nil; return }
        if value{
            selectedSwitch?.setOn(false, animated: true)
            selected(id)
        }else{
            staySwitch.setOn(true, animated: true)
            selected(3)
        }
    }
    
    private func selected(_ id: Int){
        selectedSwitch = switchArr[id]
        selectedId = id + 1
    }
    
    private func setBind(){
        _ = Connector.instance.getRequest(ApplyAPI.applyOrGetStayInfo, method: .get)
            .decodeData(StayModel.self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                guard let strongSelf = self else { return }
                if code == 200{
                    strongSelf.switchArr[data!.value - 1].setOn(true, animated: true)
                    strongSelf.selected(data!.value - 1)
                }else{ strongSelf.showError(code) }
            })
    }
    
}
