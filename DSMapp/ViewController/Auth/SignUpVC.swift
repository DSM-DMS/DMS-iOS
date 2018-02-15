//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController{

    @IBOutlet weak var editBoxHeight: NSLayoutConstraint!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    private var vaildChecker = [String : Bool]()
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    override func viewDidLoad() {
        setVaild(idTextField, id: .id)
        setVaild(codeTextField, id: .uuid)
        idTextField.delegate = self
        pwTextField.delegate = self
        codeTextField.delegate = self
    }
    
    @IBAction func apply(_ sender: Any) {
        if !vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        Connector.instance.request(createRequest(sub: "/signup", method: .post, params: getParam()), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                switch code{
                case 201: self.showToast(msg: "회원가입 성공", fun: self.goBack)
                case 205: self.showToast(msg: "회원가입 코드를 확인하세요")
                default: self.showError(code)
                }
            }).disposed(by: disposeBag)
    }
    
}

extension SignUpVC: UITextFieldDelegate{
    
    fileprivate func setVaild(_ textField: UITextField, id: VeryfiId){
        textField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .flatMapLatest{ [unowned self] _ in
                return Connector.instance.request(self.createRequest(sub: "/verify/\(id.rawValue)", method: .post, params: ["\(id.rawValue)" : textField.text!]), vc: self)
            }.subscribe(onNext: { [unowned self] code, _ in
                if code == 201{ print("call") }
                else if code == 204{
                    self.showToast(msg: id.getErrStr())
                    textField.text = ""
                }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func getParam() -> [String : String]{
        var param = [String : String]()
        param["uuid"] = codeTextField.text!
        param["id"] = idTextField.text!
        param["pw"] = pwTextField.text!
        return param
    }
    
    fileprivate func vaild() -> Bool{
        return ec(idTextField) && ec(pwTextField) && ec(codeTextField)
    }
    
    private func ec(_ textField: UITextField) -> Bool{
        return !textField.text!.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant += 60
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant -= 60
            self.view.layoutIfNeeded()
        })
    }
    
}

fileprivate enum VeryfiId: String{
    
    case uuid = "uuid"
    case id = "id"
    
    func getErrStr() -> String{
        switch self {
        case .uuid:
            return "유효하지 않은 코드입니다"
        case .id:
            return "아이디가 중복됩니다"
        }
    }
    
}
