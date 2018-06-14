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
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func change(_ sender: ButtonShape) {
        if vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        _ = Connector.instance
            .getRequest(AuthAPI.changePassWord, method: .post, params: getParam())
            .emptyData(vc: self)
            .subscribe(onNext: { [weak self] code in
                guard let strongSelf = self else { return }
                switch code{
                case 200: strongSelf.showToast(msg: "변경 성공", fun: self?.goBack)
                case 403: strongSelf.showToast(msg: "현재 비밀번호가 틀렸습니다.")
                strongSelf.curPwTextField.text = ""
                default: strongSelf.showError(code)
                }
            })
    }
    
    private func getParam() -> [String : String]{
        var param = [String : String]()
        param["currentPassword"] = curPwTextField.text!
        param["newPassword"] = newPwTextField.text!
        return param
    }
    
    private func vaild() -> Bool{
        return curPwTextField.text!.isEmpty || newPwTextField.text!.isEmpty
    }
    
}
