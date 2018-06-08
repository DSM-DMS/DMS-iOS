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

extension MyPageVC {
    
    private func setInit(){
        tableView.delegate = self
        tableView.dataSource = self
        studyStateLabel.numberOfLines = 2
    }
    
    private func loadData(){
        _ = Connector.instance
            .getRequest(InfoAPI.getMypageInfo, method: .get)
            .decodeData(MyPageModel.self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                if code == 200{ self?.setBind(data!) }
                else{ self?.showError(code) }
            })
    }
    
    private func setBind(_ data: MyPageModel){
        setData(study: data.getStudyState(), stay: data.getStayState(), good: data.good_point, bad: data.bad_point)
    }
    
    private func uploadBug(_ textField: UITextField){
        _ = Connector.instance
            .getRequest(ReportAPI.reportBug, method: .post, params: ["platform" : "3", "content" : textField.text!])
            .decodeData(vc: self)
            .subscribe(onNext: { [weak self] code in
                if code == 201 { self?.showToast(msg: "버그 신청 성공") }
                else{ self?.showError(code) }
            })
    }
    
    private func setData(study: String = "연장상태", stay: String = "잔류상태", good: Int = 0, bad: Int = 0){
        studyStateLabel.text = study
        stayStateLabel.text = stay
        positiveCountLabel.text = good.description
        negativeCountLabel.text = bad.description
    }
    
}

extension MyPageVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            if token.get() == nil { goNextViewWithStoryboard(storyId: "Auth", id: "SignInView") }
            else{ token.remove(); tableView.reloadData(); setData() }
        case 2:
            if token.get() == nil { showToast(msg: "로그인이 필요합니다") }
            else{ goNextViewWithStoryboard(storyId: "Auth", id: "ChangePasswordView") }
        case 3:
            if token.get() == nil { showToast(msg: "로그인이 필요합니다") }
            else{ goNextViewController("PointListView") }
        case 5:
            let alert = UIAlertController(title: "버그신고", message: nil, preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "전송", style: .default){ [unowned self] _ in self.uploadBug(alert.textFields![0]) } )
            alert.addAction(UIAlertAction.init(title: "취소", style: .cancel))
            present(alert, animated: true, completion: nil)
        case 6: goNextViewController("IntroDeveloperListView")
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleStrArr = ["", "", "비밀번호 변경","상벌점 내역 조회", "", "버그 신고", "개발자 소개"]
        switch indexPath.row {
        case 0, 4:
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            if indexPath.row == 1{ cell.titleLabel.text = token.get() == nil ? "로그인" : "로그아웃" }
            else { cell.titleLabel.text = titleStrArr[indexPath.row] }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 4:
            return 20
        default:
            return 60
        }
    }
    
}

class ContentCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
}
