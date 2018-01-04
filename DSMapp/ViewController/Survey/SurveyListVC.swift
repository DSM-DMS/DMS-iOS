//
//  SurveyVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 11..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyListVC: UITableViewController {

    var usingData = Array<SurveyListModel>()
    
    @IBAction func pressBack(_ sender: Any) { back() }
    
    override func viewDidLoad() {
        connector(add: "/survey", method:
            "GET", params: [:], fun: {
                data, code in
                if code == 200{
                    self.usingData = try! JSONDecoder().decode(Array<SurveyListModel>.self, from: data!)
                    self.tableView.reloadData()
                }else{
                    self.showToast(msg: "오류 : \(code)")
                }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyListCell", for: indexPath) as! SurveyListCell
        let selectData = usingData[indexPath.row]
        
        cell.titleLabel.text = selectData.title
        cell.id = selectData.id
        cell.dateLabel.text = "\(selectData.start_date) ~ \(selectData.end_date)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "SurveyInfoView") as! SurveyInfoVC
        contentVC.questionData = usingData[indexPath.row]
        present(contentVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usingData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
