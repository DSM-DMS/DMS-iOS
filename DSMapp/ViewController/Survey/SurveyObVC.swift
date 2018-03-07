//
//  SurveyObVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyObVC: UIViewController {
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    
    var questionTitle = ""
    var answerArr = Array<String>()
    var beforeCell: SurveyObCell? = nil
    let selectColor = UIColor.init(red: 1, green: 175/255, blue: 80/155, alpha: 1)
    
    
    var nextFunc: ((String) -> ())?
    
    @IBAction func next(_ sender: Any) {
        if let answer = beforeCell?.contentLabel.text{
            nextFunc?(answer)
        }else{
            showToast(msg: "답변을 선택해주세요")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleLabel.text = questionTitle
        answerTable.dataSource = self
        answerTable.delegate = self
    }

}

extension SurveyObVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyObCell", for: indexPath) as! SurveyObCell
        if cell == beforeCell{
            cell.contentLabel.textColor = selectColor
        }else{
            cell.contentLabel.textColor = Color.CO3.getColor()
        }
        cell.contentLabel.text = answerArr[indexPath.row]
        cell.position = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SurveyObCell
        beforeCell?.contentLabel.textColor = Color.CO3.getColor()
        cell.contentLabel.textColor = selectColor
        beforeCell = cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

class SurveyObCell: UITableViewCell{
    
    @IBOutlet weak var contentLabel: UILabel!
    var position = 0
    
}
