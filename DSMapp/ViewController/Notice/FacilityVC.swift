//
//  FacilityVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 7..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FacilityVC: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomNumTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var removeFunc: (() -> Void)? = nil
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        contentTextView.layer.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
    }
    
    @objc func addAction(_ button: UIButton){
        if button == cancelButton{ removeFunc?(); return }
        if vaild(){ showToast(msg: "모든 값을 확인하세요"); return }
        _ = Connector.instance
                .getRequest(ReportAPI.reportFacility, method: .post, params: getParam())
                .emptyData(vc: self)
                .subscribe(onNext: { [weak self] code in
                    guard let strongSelf = self else { return }
                    switch code {
                    case 201: strongSelf.showToast(msg: "신고 성공", fun: strongSelf.removeFunc)
                    default: strongSelf.showError(code)
                    }
                })
    }

}

extension FacilityVC{
    
    private func vaild() -> Bool{
        return roomNumTextField.text!.isEmpty && titleTextField.text!.isEmpty && contentTextView.text!.isEmpty
    }
    
    private func getParam() -> [String : String]{
        var param = [String : String]()
        param["room"] = roomNumTextField.text!
        param["content"] = contentTextView.text!
        return param
    }
    
}
