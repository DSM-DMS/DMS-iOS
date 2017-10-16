//
//  ChangePasswordView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 10. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class ChangePasswordView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var editHeight: NSLayoutConstraint!
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var passWordAgainField: UITextField!
    @IBOutlet weak var passwordWaringText: UILabel!
    @IBOutlet weak var passwordWaringImage: UIImageView!
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func send(_ sender: Any) {
        if password.isEmpty{
            showToast(message: "비밀번호를 입력하세요")
        }else if !passwordWaringImage.isHidden{
            showToast(message: "다시 확인하세요")
        }else{
            ap.getAPI(add: "account/password/student", param: "password=\(password)", method: "PATCH", fun: {
                data, res, err in
                if err == nil{
                    if res?.statusCode == 200{
                        DispatchQueue.main.async {
                            self.showToast(message: "비밀번호가 변경되었습니다.")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showToast(message: "변경에 실패하였습니다.")
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showToast(message: "네트워크를 확인하세요.")
                    }
                }
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGesture()
        passWordField.delegate = self
        passWordAgainField.delegate = self
        passwordWaringText.isHidden = true
        passwordWaringImage.isHidden = true
    }
    
    var password = ""
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passWordField{
            editHeight.constant.add(20)
            password = passWordField.text!
        }else{
            editHeight.constant.add(60)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passWordField{
            editHeight.constant.add(-20)
        }else{
            editHeight.constant.add(-60)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passWordAgainField{
            if password.isEmpty{
                showToast(message: "비밀번호를 입력하세요")
                return false
            }
            var temp = textField.text!
            if string.isEmpty{
                temp.characters.removeLast()
            }else{
                temp += string
            }
            
            print(temp)
            
            if password == temp{
                passwordWaringText.isHidden = true
                passwordWaringImage.isHidden = true
            }else{
                passwordWaringText.isHidden = false
                passwordWaringImage.isHidden = false
            }
        
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
