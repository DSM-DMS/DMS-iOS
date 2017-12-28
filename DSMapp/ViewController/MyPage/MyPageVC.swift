//
//  MyPageVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController {

    @IBOutlet weak var stayStateLabel: UILabel!
    @IBOutlet weak var studyStateLabel: UILabel!
    @IBOutlet weak var positiveCountLabel: UILabel!
    @IBOutlet weak var negativeCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        studyStateLabel.numberOfLines = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        connector(add: "/mypage", method: "GET", params: [:], fun: {
            data, code in
            switch code {
            case 200:
                let decoderData = try! JSONDecoder().decode(MyPageModel.self, from: data!)
                self.stayStateLabel.text = "\(self.getStayStateName(decoderData.stay_value))"
                self.studyStateLabel.text = decoderData.getStudyState()
            case 204, 401:
                self.showToast(msg: "로그인이 필요합니다.")
                self.stayStateLabel.text = "오류"
                self.studyStateLabel.text = "오류"
            default:
                self.showToast(msg: "오류 : \(code)")
            }
            
        })
    }

}

extension MyPageVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            if getToken() == nil{ goNextViewToAuth("SignInView") }
            else{
                removeToken()
                viewWillAppear(true)
            }
        case 2:
            if getToken() == nil { showToast(msg: "로그인이 필요합니다.") }
            else { goNextViewToAuth("ChangePasswordView") }
        case 4:
            let alert = UIAlertController.init(title: "버그신고", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction.init(title: "전송", style: .default, handler: {
                _ in
                let textField = alert.textFields![0]
                if textField.text!.isEmpty{
                    self.showToast(msg: "버그를 입력하세요")
                }else{
                    self.connector(add: "/bug-report", method: "POST", params: ["title" : "iOS 오류", "content" : textField.text!], fun: {
                        _, code in
                        if code == 201{
                            self.showToast(msg: "신고 성공")
                        }else{
                            self.showToast(msg: "오류 : \(code)")
                        }
                    })
                }
            }))
            
            alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        case 5:
            let alert = UIAlertController.init(title: "멋지게 준비중입니다.", message: "조금만 기다려주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    func goNextViewToAuth(_ id: String){
        let authStoryboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = authStoryboard.instantiateViewController(withIdentifier: id)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleStrArr = ["", "", "비밀번호 변경","", "버그 신고", "개발자 소개"]
        switch indexPath.row {
        case 0, 3, 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            if getToken() == nil{
                cell.titleLabel.text = "로그인"
            }else{
                cell.titleLabel.text = "로그아웃"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            cell.titleLabel.text = titleStrArr[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 3, 6:
            return 20
        default:
            return 60
        }
    }
    
}

class ContentCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
}
