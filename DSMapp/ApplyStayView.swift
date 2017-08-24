//
//  applyStayView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 6. 11..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class 
ApplyStayView: UIViewController {

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var friOut: UISwitch!
    @IBOutlet weak var satOut: UISwitch!
    @IBOutlet weak var satIn: UISwitch!
    @IBOutlet weak var stay: UISwitch!
    
    var switchArray = [UISwitch]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        switchArray = [friOut,satOut,satIn,stay]
        applyButton.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        applyButton.layer.shadowOpacity = 0.1
        applyButton.layer.shadowColor = UIColor.black.cgColor
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        ap.getAPI(add: "/apply/stay", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                if res?.statusCode == 200{
                    let curruntNum = (data as! [String:Int])["value"]!
                    DispatchQueue.main.async {
                        for i in 0..<self.switchArray.count{
                            if i == curruntNum - 1 {
                                self.switchArray[i].setOn(true, animated: true)
                            }else{
                                self.switchArray[i].setOn(false, animated: true)
                            }
                        }
                    }
                }
            }
            
        })
        
    }
    
    func returnToHome(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        returnToHome()
    }
    
    @IBAction func apply(_ sender: Any) {
        for i in 0..<switchArray.count{
            if switchArray[i].isOn{
                ap.getAPI(add: "apply/stay", param: "value=\(i+1)", method: "PUT", fun: {
                    data, res, err in
                    if err == nil{
                        if res?.statusCode == 200{
                            DispatchQueue.main.async {
                                self.showToast(message: "신청 성공", down: false)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.showToast(message: "신청 실패", down: false)
                    }
                })
                return
            }
        }
    }
    
    @IBAction func valueChange(_ sender: Any) {
        let curruntSwitch = sender as! UISwitch
        if !curruntSwitch.isOn{
            stay.setOn(true, animated: true)
        }else{
            for i in switchArray{
                if i != curruntSwitch{
                    i.setOn(false, animated: true)
                }
            }
        }
    }
    

}
