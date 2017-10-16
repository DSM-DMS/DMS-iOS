//
//  myPageView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 7. 27..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MyPageView: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var studyText: UILabel!
    
    @IBOutlet weak var stayText: UILabel!
    
    @IBOutlet weak var positivePointText: UILabel!
    
    @IBOutlet weak var negativePointText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        view1.backgroundColor = UIColor.init(red: 230/255, green: 240/255, blue: 246/255, alpha: 1)
        view2.backgroundColor = view1.backgroundColor
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    let studyRoomString = ["가온실","나온실","다온실","라온실","3층 독서실","4층 독서실","열린교실"]
    
    let stayString = ["금요귀가","토요귀가","토요귀사","잔류"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        initGetData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row % 3 == 0){
            return 20
        }else{
            return 55
        }
    }
    
    func goNextView(_ id:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: id)
        vc?.modalTransitionStyle = .crossDissolve
        present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 1:
                goNextView("AskInfoView")
            //설문조사
            case 2:
                break
            //개발자 소개
            case 4:
                goNextView("ChangePasswordView")
            //비밀번호 변경
            case 5:
                if ap.isLogin{
                    ap.getAPI(add: "account/logout/student", param: "", method: "POST", fun: {
                        data, res, err in
                        if err == nil{
                            if (res?.statusCode)! == 201{
                                self.ap.logout()
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.initGetData()
                                }
                            }
                        }
                    })
                }else{
                    self.goNextView("LoginView")
                }

            //로그인 로그아웃
            default :
                print("hello world")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0{
            let jumpCell = UITableViewCell()
            jumpCell.backgroundColor = tableView.backgroundColor
            return jumpCell
        }else if indexPath.row == 5{
            var text = ""
            if ap.isLogin{
                text = signText.1
            }else{
                text = signText.0
            }
            let showCell = MyViewCell(text: text)
            return showCell.getCell()
        }else{
            let showCell = MyViewCell(text: tableArr[indexPath.row])
            return showCell.getCell()
        }
    }
    
    let tableArr = ["","설문 조사", "개발자 소개","","비밀번호 변경", ""]
    let signText = ("로그인", "로그아웃")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func initGetData(){
        ap.getAPI(add: "apply/extension", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                DispatchQueue.main.async {
                    if res?.statusCode == 204{
                        self.studyText.text = "신청없음"
                    }else if res?.statusCode == 200{
                        let temp = data as! [String:Any]
                        var showStr = self.studyRoomString[(temp["class"] as! Int) - 1]
                        showStr += " - \(temp["seat"] as! Int)"
                        self.studyText.text = showStr
                    }else{
                        self.studyText.text = "로그인 필요"
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.studyText.text = "네트워크 오류"
                }
            }
        })
        
        ap.getAPI(add: "apply/stay", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                DispatchQueue.main.async {
                    if res?.statusCode == 204{
                        self.stayText.text = "신청없음"
                    }else if res?.statusCode == 200{
                        let temp = data as! [String:Any]
                        print(temp)
                        self.stayText.text = self.stayString[(data as! [String : Int])["value"]! - 1]
                    }else{
                        self.stayText.text = "로그인 필요"
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.stayText.text = "네트워크 오류"
                }
            }
        })
        
        ap.getAPI(add: "score", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                if res?.statusCode == 200{
                    let temp = data as! [String:Int]
                    DispatchQueue.main.async {
                        self.positivePointText.text = "\(temp["merit"]!)"
                        self.negativePointText.text = "\(temp["demerit"]!)"
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.positivePointText.text = "오류"
                self.negativePointText.text = "오류"
            }
        })

    }
}
