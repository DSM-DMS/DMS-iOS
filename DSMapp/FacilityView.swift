//
//  FacilityView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 24..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class FacilityView: UIViewController, UITextViewDelegate{

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var view1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        contentTextView.layer.cornerRadius = 5
        contentTextView.text = "정보를 입력하십시오"
        
        titleTextField.placeholder = "신고 제목을 입력하세요"
        roomNumberTextField.placeholder = "호실 번호를 입력하세요"
        roomNumberTextField.keyboardType = .numberPad
        view1.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
}
