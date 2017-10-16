//
//  ApplyAfterSchoolInfo.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 9. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class ApplyAfterSchoolInfo: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var finishDateLabel: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.cornerRadius = 14
        nextButton.layer.cornerRadius = 25
        nextButton.layer.backgroundColor = UIColor.init(red: 167 / 255, green: 201 / 255, blue: 218 / 255, alpha: 1).cgColor
        nextButton.addTarget(self, action: #selector(goNext(_:)), for: .touchUpInside)
        
        getData()
    }
    
    func getData(){
        ap.getAPI(add: "afterschool", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil {
                if res?.statusCode == 200{
                    
                }else if res?.statusCode == 204{
                    DispatchQueue.main.async {
                        self.moreInfoTextView.text = "방과후 신청 기간이 아닙니다."
                        self.isAble = false
                    }
                }else{
                    
                }
            }else{
                DispatchQueue.main.async {
                    self.showToast(message: "네트워크를 확인하세요")
                }
            }
        })
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    var isAble = true
    
    func goNext(_ sender : UIButton){
        if !isAble{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "applyAfterStudyContent")
            vc?.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        }else{
            showToast(message: "기간이 아닙니다.")
        }
    }
}
