//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var editBoxHeight: NSLayoutConstraint!
    
    var idCheck = false
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        idTextField.delegate = self
        pwTextField.delegate = self
        codeTextField.delegate = self
    }
    
    @IBAction func apply(_ sender: Any) {
        if tFSC(idTextField) || tFSC(pwTextField) || tFSC(codeTextField) || !idCheck{
            connector(add: "/signup", method: "POST", params: ["uuid" : codeTextField.text!, "id" : idTextField.text!, "pw" : pwTextField.text!], fun: {
                _, code in
                switch code{
                case 201:
                    self.showToast(msg: "회원가입 성공", fun: self.back)
                case 400:
                    self.showToast(msg: "회원가입 코드를 확인하세요")
                default:
                    self.showToast(msg: " : \(code)")
                }
            })
        }else{
            showToast(msg: "값을 다 입력하세요.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant += 60
            self.view.layoutIfNeeded()
        })
        
        if textField == idTextField{
            connector(add: "/verify/id", method: "POST", params: ["id" : idTextField.text!], fun: {
                _, code in
                if code == 201{
                    self.idCheck = true
                }else{
                    self.idCheck = false
                    self.idTextField.text = ""
                    self.showToast(msg: "아이디 중복")
                }
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant -= 60
            self.view.layoutIfNeeded()
        })
    }
    
    
    func tFSC(_ textField: UITextField) -> Bool{
        return textField.text!.isEmpty
    }
    
}
