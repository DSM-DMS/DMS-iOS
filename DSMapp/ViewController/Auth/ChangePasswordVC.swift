//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ChangePasswordVC: UIViewController{

    @IBOutlet weak var curPwTextField: UITextField!
    @IBOutlet weak var newPwTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func change(_ sender: ButtonShape) {
        if !vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        Connector.instance.request(createRequest(sub: "/change/pw", method: .post, params: getParam()), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                switch code{
                case 200: self.showToast(msg: "변경 성공", fun: self.goBack)
                case 403: self.showToast(msg: "비밀번호를 다시 입력하세요")
                    self.curPwTextField.text = ""
                default: self.showError(code)
                }
            }).disposed(by: disposeBag)
    }
    
    private func getParam() -> [String : String]{
        var param = [String : String]()
        param["current_pw"] = curPwTextField.text!
        param["new_pw"] = newPwTextField.text!
        return param
    }
    
    private func vaild() -> Bool{
        return curPwTextField.text!.isEmpty && newPwTextField.text!.isEmpty
    }
    
}
