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
    
    private let disposeBag = DisposeBag()
    private let titleTextArr = ["기숙사 규정", "공지사항", "자주 하는 질문"]
    
    var id: Int = 0
    var url = ""
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
        Connector.instance.request(createRequest(sub: url, method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    self.data = try! JSONDecoder().decode([NoticeListModel].self, from: data).reversed()
                    if self.data.count > 0 { self.tableView.reloadData() }
                    else{ self.showAlert() }
                }else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "\(titleTextArr[id])이 없습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in self.goBack() }))
        present(alert, animated: true, completion: nil)
    }
    
    func setData(){
        let imageStrArr = ["monster1", "monster2", "monster3"]
        let urlArr = ["/rule", "/notice", "/faq"]
        titleLabel.text = titleTextArr[id]
        url = urlArr[id]
        monsterImageView.image = UIImage(named: imageStrArr[id])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoticeDetailView") as! NoticeDetailVC
        vc.url = "\(url)/\(data[indexPath.row].id)"
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
