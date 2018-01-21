//
//  SurveyNObVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyNObVC: UIViewController {

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    
    var questionTitle = ""
    var nextFunc: ((String) -> ())?
    
    @IBAction func next(_ sender: Any) {
        if !answerTextField.text!.isEmpty{
            nextFunc?(answerTextField.text!)
        }else{
            showToast(msg: "답변을 입력해주세요")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleLabel.text = questionTitle
        answerTextField.delegate = self
    }

}

extension SurveyNObVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.answerTextField.center.y -= 120
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: {
            self.answerTextField.center.y += 120
        })
    }
    
}
