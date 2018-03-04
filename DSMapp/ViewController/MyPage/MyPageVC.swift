//
//  MyPageVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift

class MyPageVC: UIViewController {

    @IBOutlet weak var stayStateLabel: UILabel!
    @IBOutlet weak var studyStateLabel: UILabel!
    @IBOutlet weak var positiveCountLabel: UILabel!
    @IBOutlet weak var negativeCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let token = Token.instance
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setInit()
    }
    
    override func viewWillAppear(_ animated: Bool){
        loadData()
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }

}

extension MyPageVC: UITableViewDataSource, UITableViewDelegate{
    
    private func setInit(){
        tableView.delegate = self
        tableView.dataSource = self
        studyStateLabel.numberOfLines = 2
    }
    
    private func loadData(){
        Connector.instance.request(createRequest(sub: "/mypage", method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    let data = try! JSONDecoder().decode(MyPageModel.self, from: data)
                    self.setBind(data)
                }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func setBind(_ data: MyPageModel){
        setData(study: data.getStudyState(), stay: data.getStayState(), good: data.good_point, bad: data.bad_point)
    }
    
    private func uploadBug(_ textField: UITextField){
        Connector.instance.request(createRequest(sub: "/report/bug", method: .post, params: ["title" : "iOS 오류", "content" : textField.text!]), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                if code == 201{ self.showToast(msg: "버그 신청 성공") }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func setData(study: String = "연장상태", stay: String = "잔류상태", good: Int = 0, bad: Int = 0){
        studyStateLabel.text = study
        stayStateLabel.text = stay
        positiveCountLabel.text = good.description
        negativeCountLabel.text = bad.description
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            if token.get().isEmpty{ goNextViewWithStoryboard(storyId: "Auth", id: "SignInView") }
            else{ token.remove(); tableView.reloadData(); setData() }
        case 2:
            if token.get().isEmpty{ showToast(msg: "로그인이 필요합니다") }
            else { goNextViewWithStoryboard(storyId: "Auth", id: "ChangePasswordView") }
        case 4:
            let alert = UIAlertController(title: "버그신고", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "전송", style: .default){ _ in self.uploadBug(alert.textFields![0]) } )
            alert.addAction(UIAlertAction.init(title: "취소", style: .cancel))
            present(alert, animated: true, completion: nil)
        case 5: goNextViewController("IntroDeveloperListView")
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleStrArr = ["", "", "비밀번호 변경","", "버그 신고", "개발자 소개"]
        switch indexPath.row {
        case 0, 3, 6:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            cell.titleLabel.text = token.get().isEmpty ? "로그인" : "로그아웃"
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
