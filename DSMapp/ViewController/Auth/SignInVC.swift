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
    
    let disposeBag = DisposeBag()
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    override func viewDidLoad() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    @IBAction func login(_ sender: Any) {
        if vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        Connector.instance.request(createRequest(sub: "/auth", method: .post, params: getParam()), vc: self, check401: false)
            .subscribe(onNext: { [unowned self] code, data in
                switch code{
                case 200:
                    let data = try! JSONDecoder().decode(AuthModel.self, from: data)
                    Token.instance.save(data.access_token)
                    self.showToast(msg: "로그인 성공", fun: self.goBack)
                case 401:
                    self.showToast(msg: "로그인 실패")
                default:
                    self.showError(code)
                }
            }).disposed(by: disposeBag)
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
        param["pw"] = pwTextField.text!
        return param
    }
    
    private func vaild() -> Bool{
        return idTextField.text!.isEmpty || pwTextField.text!.isEmpty
    }
    
}

class SighInTextFieldShape: UITextField{
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        setLayout()
    }
    
    private func setLayout(){
        clipsToBounds = true
        let noneColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).cgColor
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1.5
        layer.borderColor = noneColor
        rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [unowned self] _ in
                self.layer.borderColor = Color.MINT.getColor().cgColor
            }).disposed(by: disposeBag)
        rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                self.layer.borderColor = noneColor
            }).disposed(by: disposeBag)
    }
    
}
