//
//  SurveyObVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyObVC: UIViewController {

    var beforeCell: SurveyObCell? = nil
    let selectColor = UIColor.init(red: 1, green: 175/255, blue: 80/155, alpha: 1)
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    
    var nextFunc: (() -> ())?
    
    @IBAction func next(_ sender: Any) {
        nextFunc?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.contentLabel.text = "hello world"
        cell.position = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SurveyObCell
        cell.contentLabel.textColor = selectColor
        beforeCell?.contentLabel.textColor = Color.CO3.getColor()
        beforeCell = cell
    }
    
}

class SurveyObCell: UITableViewCell{
    
    @IBOutlet weak var contentLabel: UILabel!
    var position = 0
    
}
