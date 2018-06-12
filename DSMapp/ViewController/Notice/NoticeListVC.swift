//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NoticeListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monsterImageView: UIImageView!
    
    var id: Int = 0
    private var data = [NoticeListModel]()
    
    override func viewDidLoad() {
        setData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func back(_ sender: Any) {
        self.goBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
}

extension NoticeListVC: UITableViewDataSource, UITableViewDelegate{
    
    func loadData(){
        _ = Connector.instance
                .getRequest(NoticeAPI.getNoticeList(category: NoticeUtil.urlArr[id]), method: .get)
                .decodeData([NoticeListModel].self, vc: self)
                .subscribe(onNext: { [weak self] code, data in
                    guard let strongSelf = self else { return }
                    if code == 200{
                        if data!.count > 0 { strongSelf.data = data!; strongSelf.tableView.reloadData() }
                        else{ strongSelf.showAlert() }
                    }else{ strongSelf.showError(code) }
                })
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "\(NoticeUtil.titleTextArr[id])가 없습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in self.goBack() }))
        present(alert, animated: true, completion: nil)
    }
    
    func setData(){
        titleLabel.text = NoticeUtil.titleTextArr[id]
        monsterImageView.image = UIImage(named: NoticeUtil.listImageIdArr[id])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoticeDetailView") as! NoticeDetailVC
        vc.id = id
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath) as! NoticeListCell
        let selectData = data[indexPath.row]
        cell.titleLabel.text = selectData.title
        cell.dateLabel.text = selectData.write_time
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
}

class NoticeListCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        titleLabel.textColor = Color.CO2.getColor()
    }
    
}
