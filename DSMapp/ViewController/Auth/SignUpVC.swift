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
        if vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        _ = Connector.instance
            .getRequest(AuthAPI.signUp, method: .post, params: getParam())
            .decodeData(vc: self)
            .subscribe(onNext: { [weak self] code in
                guard let strongSelf = self else { return }
                switch code{
                case 201: strongSelf.showToast(msg: "회원가입 성공", fun: self.goBack)
                case 205: strongSelf.showToast(msg: "회원가입 코드를 확인하세요")
                default: strongSelf.showError(code)
                }
            })
    }
    
}

extension SignUpVC: UITextFieldDelegate{
    
    private func setVaild(_ textField: UITextField, id: VeryfiId){
        textField.rx.text.orEmpty.filter{ !$0.isEmpty }
            .flatMapLatest{ [unowned self] str in
                Connector.instance.getRequest(AuthAPI.verifyID, method: .post, params: [id.rawValue : str])
                    .decodeData(vc: self)
            }.subscribe(onNext: { [unowned self] code, _ in
                if code == 204{ self.showToast(msg: id.getErrStr()) }
                else if code != 200{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func getParam() -> [String : String]{
        var param = [String : String]()
        param["uuid"] = codeTextField.text!
        param["id"] = idTextField.text!
        param["pw"] = pwTextField.text!
        return param
    }
    
    private func vaild() -> Bool{
        return ec(idTextField) || ec(pwTextField) || ec(codeTextField)
    }
    
    private func ec(_ textField: UITextField) -> Bool{
        return textField.text!.isEmpty
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
