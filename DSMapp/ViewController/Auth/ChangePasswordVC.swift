//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordVC: UIViewController{

    @IBOutlet weak var curPwTextField: UITextField!
    @IBOutlet weak var newPwTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    @IBAction func change(_ sender: ButtonShape) {
        if curPwTextField.text!.isEmpty || newPwTextField.text!.isEmpty{
            showToast(msg: "값을 다 입력하세요")
        }else{
            connector(add: "/change/pw", method: "POST", params: ["current_pw" : curPwTextField.text!, "new_pw" : newPwTextField.text!], fun: {
                _, code in
                if code == 200{ self.showToast(msg: "변경 성공", fun: self.back) }
                else if code == 403{ self.showToast(msg: "비밀번호가 틀렸습니다") }
                else{ self.showToast(msg: "오류 : \(code)") }
            })
        }
    }
    
    
}
