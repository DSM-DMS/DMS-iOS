//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class SignInVC: UIViewController{

    @IBOutlet weak var editBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    @IBAction func login(_ sender: Any) {
        connector(add: "/auth", method: "POST", params: ["id" : idTextField.text!, "pw" : pwTextField.text!], fun: {
            data, code in
            if code == 200{
                let tokenClass = try! JSONDecoder().decode(AuthModel.self, from: data!)
                self.saveToken(tokenClass.access_token)
                self.showToast(msg: "로그인 성공", fun: self.back)
            }else{
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }
    
}

extension SignInVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.editBoxHeight.constant -= 100
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.editBoxHeight.constant += 100
            self.view.layoutIfNeeded()
        })
    }
    
}
