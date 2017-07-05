//
//  applyView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 30..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class applyView: UIViewController {

    @IBOutlet weak var viewStudy: UIView!
    @IBOutlet weak var viewStay: UIView!
    @IBOutlet weak var viewOut: UIView!
    @IBOutlet weak var viewGood: UIView!
    
    
    @IBOutlet weak var textStudy: UILabel!
    @IBOutlet weak var textStay: UILabel!
    @IBOutlet weak var textGood: UILabel!
    
    @IBOutlet weak var OutSat: UISwitch!
    @IBOutlet weak var OutSun: UISwitch!
    
    @IBOutlet weak var openStudy: UIButton!
    @IBOutlet weak var openStay: UIButton!
    @IBOutlet weak var openOut: UIButton!
    @IBOutlet weak var openGood: UIButton!
    
    var viewArray = [UIView]()
    var textArray = [UILabel]()
    var openButtonArray = [UIButton]()
    
    let KEY = ".s@!31VAsv!@312231"
    
    var check = [false,false,false,false,false]
    
    override func viewWillAppear(_ animated: Bool) {
        var tempNum = 0
        for i in 0..<check.count{
            if check[i]{
                tempNum = i
            }
        }
        
        if tempNum == 2{
            getDataForSwitch()
        }else{
            getData(num: tempNum, label: textArray[tempNum])
        }
    }
    
    override func viewDidLoad() {
        viewStudy.backgroundColor = UIColor.init(red: 167/255, green: 201/255, blue: 218/255, alpha: 1)
        viewStay.backgroundColor = UIColor.init(red: 137/255, green: 185/255, blue: 209/255, alpha: 1)
        viewOut.backgroundColor = UIColor.init(red: 117/255, green: 177/255, blue: 208/255, alpha: 1)
        viewGood.backgroundColor = UIColor.init(red: 99/255, green: 160/255, blue: 191/255, alpha: 1)
        
        viewArray = [viewStudy,viewStay,viewOut,viewGood]
        openButtonArray = [openStudy,openStay,openOut,openGood]
        textArray = [textStudy,textStay,UILabel(),textGood]
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !check[0]{
            UIView.animate(withDuration: TimeInterval(0.25), animations: {
                self.viewStudy.center.y -= 135
            })
            openStudy.setTitle("신청", for: UIControlState.normal)
            check[0] = true
            getData(num: 0, label: textStudy)
        }
    }

    @IBAction func setUp_Down(_ sender: Any) {
        var tempInt = Int()
        
        for i in 0..<openButtonArray.count{
            if (sender as! UIButton) == openButtonArray[i]{
                tempInt = i
                break
            }
        }
        
        if openButtonArray[tempInt].title(for: .normal) == "신청" && textArray[tempInt].text != "네트워크를 확인하세요."{
            switch tempInt {
            case 2:
                var temp = (false,false)
                ap.getAPI(add: "apply/goingout", param: "sat=\(OutSat.isOn)&sun=\(OutSun.isOn)", method: "PUT", fun: {
                    data, res, err in
                    
                    if (err == nil)&&(res?.statusCode == 200){
                        temp.0 = true
                    }
                    
                    temp.1 = true
                })
                
                while !temp.1{
                }
                
                if temp.0{
                    showToast(message: "신청 성공")
                }else {
                    showToast(message: "신청 실패")
                }
                
            case 3:
                return
            default:
                let storyboardIDArray = ["applyStudy","applyStay"]
                let uvc = self.storyboard?.instantiateViewController(withIdentifier: storyboardIDArray[tempInt])
                uvc?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                present(uvc!, animated: true, completion: nil)
            }
            return
        }
        
        if tempInt == 2{
            getDataForSwitch()
        }else{
            getData(num: tempInt, label: textArray[tempInt])
        }
        
        UIView.animate(withDuration: TimeInterval(0.25), animations: {
            if (self.check[tempInt] == true)&&(self.check[tempInt+1] == false){
                return
            }
            
            for i in 0...tempInt{
                self.openButtonArray[i].setTitle("열기", for: UIControlState.normal)
                if !self.check[i]{
                    self.viewArray[i].center.y -= 135
                    self.check[i] = !self.check[i]
                }
            }
            
            for i in tempInt+1..<4{
                self.openButtonArray[i].setTitle("열기", for: UIControlState.normal)
                if self.check[i]{
                    self.viewArray[i].center.y += 135
                    self.check[i] = !self.check[i]
                }
            }
            
            (sender as! UIButton).setTitle("신청", for: UIControlState.normal)
        })
        
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    let urlArray = ["apply/extension","apply/stay","apply/goingout",""]
    
    
    func getData(num: Int, label:UILabel){
        
        var getData = ""
        let studyRoomNumber = ["가온실","나온실","다온실","라온실","3층 독서실","4층 독서실","열린교실"]
        let stayString = ["금요귀가","토요귀가","토요귀사","잔류"]

        
        if num == 3{
            label.text = "서비스 준비 중 입니다."
            return
        }
        
        if ap.isLogin{
            ap.getAPI(add: urlArray[num], param: "", method: "GET", fun: {
                data, res, error in
                if error == nil{
                    if res?.statusCode == 204{
                        getData = "신청되지 않았습니다"
                    }else if res?.statusCode == 200{
                        if num == 0{
                            let temp = data as! [String:Any]
                            self.ap.myName = temp["name"] as! String
                            print(self.ap.myName)
                            getData = "신청 : " + studyRoomNumber[(temp["class"] as! Int) - 1]
                        }
                        if num == 1{
                            getData = "신청 : " + stayString[(data as! [String : Int])["value"]! - 1]
                        }
                    }
                }
            })
        }else{
            label.text = "로그인이 필요합니다."
            return
        }
        
        
        while true{
            if !getData.isEmpty{
                break;
            }
        }
        
        label.text = getData;
    }
    
    func getDataForSwitch(){
        let switchArray = [OutSat,OutSun]
        var dataCheck = [false,false,false,false]
        if !ap.isLogin{
            for i in switchArray{
                i?.isEnabled = false
            }
            return
        }

        ap.getAPI(add: urlArray[2], param: "", method: "GET", fun: {
            data, res, error in
            if error == nil{
                if res?.statusCode == 200{
                    dataCheck[0] = true
                    let temp = data as! [String : Bool]
                    dataCheck[1] = temp["sat"]!
                    dataCheck[2] = temp["sun"]!
                }
            }
            
            dataCheck[3] = true
        })
        
        while true {
            if dataCheck[3] == true{
                break;
            }
        }
        
        for i in switchArray{
            i?.isEnabled = dataCheck[0]
        }
        
        if dataCheck[0] == true{
            OutSat.setOn(dataCheck[1], animated: true)
            OutSun.setOn(dataCheck[2], animated: true)
        }
    }

}
