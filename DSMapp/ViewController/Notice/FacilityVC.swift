//
//  FacilityVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 7..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class FacilityVC: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var roomNumTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    public var removeFunc: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        contentTextView.layer.cornerRadius = 4
        
        cancelButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
    }
    
    @objc func addAction(_ button: UIButton){
        if button == sendButton{
            if titleTextField.text!.isEmpty || roomNumTextField.text!.isEmpty || contentTextView.text.isEmpty{
                showToast(msg: "모든 값을 입력하세요")
            }else{
                connector(add: "/report/facility", method: "POST", params: ["room" : roomNumTextField.text!, "title" : titleTextField.text!, "content" : contentTextView.text], fun: {
                    _, code in
                    if code == 201{
                        self.showToast(msg: "신고 성공", fun: self.removeFunc)
                    }else{
                        self.showToast(msg: "오류 : \(code)")
                    }
                })
            }
        }else{
            removeFunc?()
        }
    }

}
