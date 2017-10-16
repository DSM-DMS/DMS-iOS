//
//  signUpView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 1..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SignUpView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordWarningText: UILabel!
    @IBOutlet weak var passwordWarningImage: UIImageView!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var idLine: UIView!
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var codeLine: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var passwordAgainLine: UIView!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    @IBOutlet weak var editTextHeight: NSLayoutConstraint!
    
    var textArray = [UITextField]()
    var lineArray = [UIView]()
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGesture()
        
        textArray = [idText,codeText,passwordText,passwordAgainText]
        lineArray = [idLine,codeLine,passwordLine,passwordAgainLine]

        button.backgroundColor = UIColor.init(red: 171/255, green: 228/255, blue: 206/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.white, for: .normal)
        passwordWarningText.isHidden = true
        passwordWarningImage.isHidden = true
    }
    
    func signUp(_ sender : UIButton){
        for i in textArray{
            if (i.text?.isEmpty)!{
                showToast(message: "모든 값을 입력하세요")
                return
            }
        }
        
        if !passwordWarningText.isHidden{
            showToast(message: "비밀번호를 다시 확인하세요")
            return
        }
        
        ap.getAPI(add: "account/register/student", param: "uid=\(codeText.text!)&id=\(idText.text!)&password=\(passwordText.text!)", method: "POST", fun: {
            data, res, err in
            DispatchQueue.main.async {
                if err == nil{
                    if res?.statusCode == 201{
                        self.showToast(message: "회원가입 성공")
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }else{
                        self.showToast(message: "회원가입 실패")
                    }
                }else{
                    self.showToast(message: "네트워크를 확인하세요")
                }
            }
        })
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<textArray.count{
            if textField == textArray[i]{
                lineArray[i].backgroundColor = UIColor.black
                editTextHeight.constant.add(CGFloat(20 * i))
                break
            }
        }
        
        if textField == idText{
            ap.getAPI(add: "account/idcheck/student", param: "id=\(textField.text!)", method: "POST", fun: {
                data, res, err in
                DispatchQueue.main.async {
                    if err == nil{
                        if res?.statusCode == 201{
                            self.idLine.backgroundColor = UIColor.init(red: 32/255, green: 149/255, blue: 134/255, alpha: 1)
                        }else{
                            self.idLine.backgroundColor = UIColor.red
                            textField.text = ""
                            self.showToast(message: "아이디가 중복됩니다.", down: false)
                        }
                    }else{
                        self.showToast(message: "네트워크를 확인하세요", down: false)
                        self.idLine.backgroundColor = UIColor.red
                        textField.text = ""
                    }
                }
            })
        }else if textField == passwordText{
            passwordData = textField.text!
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordAgainText{
            if passwordData.isEmpty{
                showToast(message: "비밀번호를 입력하세요", down: false)
                return false
            }else{
                var data = textField.text!
                if string.isEmpty{
                    data.characters.removeLast()
                }else{
                    data += string
                }
                if data == passwordData{
                    passwordWarningText.isHidden = true
                    passwordWarningImage.isHidden = true
                }else{
                    passwordWarningText.isHidden = false
                    passwordWarningImage.isHidden = false
                }
            }
        }
        return true
    }
    
    var passwordData = ""
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for i in 0..<textArray.count{
            if textField == textArray[i]{
                lineArray[i].backgroundColor = UIColor.init(red: 32/255, green: 149/255, blue: 134/255, alpha: 1)
                editTextHeight.constant.add(CGFloat(-20 * i))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
