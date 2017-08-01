//
//  signUpView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 1..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class signUpView: UIViewController, UITextFieldDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textArray = [idText,codeText,passwordText,passwordAgainText]
        lineArray = [idLine,codeLine,passwordLine,passwordAgainLine]

        button.backgroundColor = UIColor.init(red: 171/255, green: 228/255, blue: 206/255, alpha: 1)
        button.layer.cornerRadius = 18
        button.setTitleColor(UIColor.white, for: .normal)
        passwordWarningText.isHidden = true
        passwordWarningImage.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0..<textArray.count{
            if textField == textArray[i]{
                lineArray[i].backgroundColor = UIColor.black
                editTextHeight.constant.add(CGFloat(20 * i))
                if textField.text!.isEmpty{
                    showToast(message: "값을 입력하세요", down: false)
                    lineArray[i].backgroundColor = UIColor.red
                    return
                }
                break
            }
        }
        
        if textField == idText{
            ap.getAPI(add: "account/idcheck/student", param: "id=\(textField.text!)", method: "POST", fun: {
                data, res, err in
                DispatchQueue.main.async {
                    if err == nil{
                        if res?.statusCode == 201{
                            
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
    
    var passwordData = String()
    
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
