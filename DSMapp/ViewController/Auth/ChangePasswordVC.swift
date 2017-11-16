//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordVC: UIViewController{

    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var curpwTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func change(_ sender: Any) {
        if pwdTextField.text!.isEmpty || curpwTextField.text!.isEmpty{
            showToast(msg: "모든 값을 입력하세요.")
        }else{
            connector(add: "/change/pw", method: "POST", params: ["current_pw" : curpwTextField.text!, "new_pw" : pwdTextField.text!], fun: {
                _, code in
                switch code{
                case 201:
                    self.back()
                case 403:
                    self.showToast(msg: "비밀번호가 틀렸습니다.")
                default:
                    self.showToast(msg: "오류 : \(code)")
                }
            })
        }
    }
    
    @IBAction func back(_ sender: Any) {
        back()
    }
    
}
