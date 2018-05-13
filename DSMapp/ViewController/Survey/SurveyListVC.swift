//
//  SurveyVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 11..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift

class SurveyListVC: UITableViewController {

    private var data = Array<SurveyListModel>()
    private let disposeBag = DisposeBag()
    
    @IBAction func pressBack(_ sender: Any) { goBack() }
    
    override func viewDidLoad() {
        Connector.instance.request(createRequest(sub: "/survey", method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    self.data = try! JSONDecoder().decode(Array<SurveyListModel>.self, from: data).reversed()
                    if self.data.count > 0{ self.tableView.reloadData() }
                    else{ self.showAlert() }
                }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyListCell", for: indexPath) as! SurveyListCell
        let selectData = data[indexPath.row]
        cell.titleLabel.text = selectData.title
        cell.id = selectData.id
        cell.dateLabel.text = "\(selectData.start_date) ~ \(selectData.end_date)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "SurveyInfoView") as! SurveyInfoVC
        contentVC.questionData = data[indexPath.row]
        navigationController?.pushViewController(contentVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    private func showAlert(){
        let alert = UIAlertController(title: "설문조사가 없습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in self.goBack() }))
        present(alert, animated: true, completion: nil)
    }
    
}

class SurveyListCell: UITableViewCell{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var id : String?
    
    override func awakeFromNib() {
        titleLabel.textColor = Color.CO2.getColor()
    }
    
}
