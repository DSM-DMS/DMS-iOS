//
//  loginView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class loginView: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var idTextFiled: UITextField!
    @IBOutlet weak var pwTextFiled: UITextField!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        select()
        autoSwitch.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        idTextFiled.layer.cornerRadius = 15
        pwTextFiled.layer.cornerRadius = 15
        idTextFiled.layer.borderWidth = 1.5
        pwTextFiled.layer.borderWidth = 1.5
        idTextFiled.layer.borderColor = UIColor.white.cgColor
        pwTextFiled.layer.borderColor = UIColor.white.cgColor
        
        //----------------------------------
        
        loginButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        loginButton.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        loginButton.layer.shadowOpacity = 0.3
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if ap.login(id: idTextFiled.text!,pw:pwTextFiled.text!){
            if autoSwitch.isOn{
                saveLogin()
            }
            showToast(message: "로그인 성공")
        }else{
            showToast(message: "로그인 실패")
        }
        idTextFiled.text = ""
        pwTextFiled.text = ""
    }
    
    func saveLogin(){
        if ap.db?.open() != nil{
            let sql_query = "update login set id = '\(idTextFiled.text!)', password = '\(pwTextFiled.text!)' where key = 'user'"
            
            ap.db?.executeUpdate(sql_query, withArgumentsIn: nil)
            
        }
        
        ap.db?.close()
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.init(red: 186/255, green: 233/255, blue: 216/255, alpha: 1).cgColor
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func finishType(_ sender: UITextField) {
        if(sender == idTextFiled){
            pwTextFiled.becomeFirstResponder()
            return
        }
        self.view.endEditing(true)
    }
    
    
    
    func select(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow(notification: Notification){
        self.idLabel.textColor = UIColor.init(red: 167/255, green: 201/255, blue: 218/255, alpha: 1)
        if(self.idTextFiled.layer.borderColor == UIColor.white.cgColor){
            self.idTextFiled.layer.borderColor = UIColor.init(red: 167/255, green: 201/255, blue: 218/255, alpha: 1).cgColor
        }
        
        if(stackView.frame.origin.y == 0){
            stackView.frame.origin.y.add(-100)
        }
        
    }
    
    func keyboardDown(notification: Notification){
        self.idLabel.textColor = UIColor.white
        stackView.frame.origin.y.add(100)
        self.idTextFiled.layer.borderColor = UIColor.white.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}
