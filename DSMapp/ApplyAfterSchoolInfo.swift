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
        
        ap.getAPI(add: "/afterschool", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
            }else{
                self.showToast(message: "네트워크를 확인하세요")
            }
        })
        
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    func goNext(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "applyAfterStudyContent")
        vc?.modalTransitionStyle = .crossDissolve
        self.present(vc!, animated: true, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "applyAfterStudy")
            vc?.dismiss(animated: false, completion: nil)
        })
    }
}
