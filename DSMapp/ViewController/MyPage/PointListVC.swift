//
//  PointListVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 3. 10..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PointListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataArr = [PointModel]()
    
    @IBAction func goBack(_ sender: Any) {
        self.goBack()
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        getData()
    }
    
    private func getData(){
        _ = Connector.instance
            .getRequest(InfoAPI.getPointInfo, method: .get)
            .decodeData([PointModel].self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                guard let strongSelf = self else { return }
                if code == 200{
                    if data!.count > 0 { strongSelf.showAlert(); return }
                    strongSelf.dataArr = data!.reversed()
                    strongSelf.tableView.reloadData()
                }
                else { strongSelf.showError(code) }
            })
    }

}

extension PointListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointContentCell", for: indexPath) as! PointContentCell
        cell.setPoint(data.point, type: data.pointType)
        cell.dateLabel.text = data.time
        cell.titleLabel.text = data.reason
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "상벌점 내역이 없습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in self.goBack() }))
        present(alert, animated: true, completion: nil)
    }
    
}

class PointContentCell: UITableViewCell{
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let redColor = UIColor(red: 250/255, green: 49/255, blue: 29/255, alpha: 1)
    private let blueColor = UIColor(red: 48/255, green: 146/255, blue: 207/255, alpha: 1)
    
    func setPoint(_ num: Int, type: Bool){
        titleLabel.textColor = type ? blueColor : redColor
        pointLabel.text = "\(type ? "+" : "-")\(num)"
    }
    
}
