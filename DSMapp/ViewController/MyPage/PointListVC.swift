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
        Connector.instance.request(createRequest(sub: "/point/history", method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    self.dataArr = try! JSONDecoder().decode([PointModel].self, from: data).reversed()
                    print(self.dataArr.count)
                    self.tableView.reloadData()
                }
                else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }

}

extension PointListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointContentCell", for: indexPath) as! PointContentCell
        cell.setPoint(data.point, type: data.point_type)
        cell.dateLabel.text = data.time
        cell.titleLabel.text = data.reason
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
