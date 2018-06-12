//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SignInVC: UIViewController{

    @IBOutlet weak var editBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var idTextField: SighInTextFieldShape!
    @IBOutlet weak var pwTextField: SighInTextFieldShape!
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    override func viewDidLoad() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    @IBAction func login(_ sender: Any) {
        if vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        _ = Connector.instance
            .getRequest(AuthAPI.signIn, method: .post, params: getParam())
            .decodeData(AuthModel.self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                switch code{
                case 201: Token.instance.save(data!); self?.showToast(msg: "로그인 성공", fun: self?.goBack)
                case 401: self?.showToast(msg: "로그인 실패")
                default: self?.showError(code)
                }
            })
    }
    
}

extension SignInVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant -= 100
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.editBoxHeight.constant += 100
            self.view.layoutIfNeeded()
        })
    }
    
    private func getParam() -> [String : String]{
        var param = [String : String]()
        param["id"] = idTextField.text!
        param["password"] = pwTextField.text!
        return param
    }
    
    private func vaild() -> Bool{
        return idTextField.text!.isEmpty || pwTextField.text!.isEmpty
    }
    
}

public class SighInTextFieldShape: UITextField{
    
    private let disposeBag = DisposeBag()
    private let noneColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).cgColor
    
    override public func awakeFromNib() {
        setLayout()
    }
    
    private func setLayout(){
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1.5
        layer.borderColor = noneColor
        Observable
            .merge([ rx.controlEvent(.editingDidBegin).asObservable().map{ return "begin" },
                     rx.controlEvent(.editingDidEnd).asObservable().map{ return "end" } ])
            .subscribe(onNext: { [unowned self] str in
                if str == "begin"{ self.layer.borderColor = Color.MINT.getColor().cgColor }
                else{ self.layer.borderColor = self.noneColor }
            }).disposed(by: disposeBag)
    }
    
}
