//
//  SurveyInfoVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 29..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class SurveyInfoVC: UIViewController {
    
    @IBOutlet weak var questionListTable: UITableView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var questionList = Array<SurveyModel>()
    var questionData: SurveyListModel?
    
    @IBAction func next(_ sender: Any) {
        let surveyPageVC = storyboard?.instantiateViewController(withIdentifier: "SurveyPageView") as! SurveyPageVC
        surveyPageVC.contentList = questionList
        navigationController?.pushViewController(surveyPageVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionListTable.dataSource = self
        
        timeLabel.text = "설문 종료일 : \(questionData!.end_date)"
        timeLabel.textAlignment = .center
        titleLabel.text = questionData!.title
        infoTextView.text = questionData!.description
        
        connector(add: "/survey/question", method: "GET", params: ["survey_id" : questionData!.id], fun: {
            data, code in
            if code == 200{
                self.questionList = try! JSONDecoder().decode(Array<SurveyModel>.self, from: data!)
                self.questionListTable.reloadData()
            }
        })
    }

}

extension SurveyInfoVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyInfoCell", for: indexPath) as! SurveyInfoCell
        cell.contentLabel.text = questionList[indexPath.row].title
        return cell
    }
    
}

class SurveyInfoCell: UITableViewCell{
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.backgroundColor = Color.CO2.getColor()
        dotView.layer.cornerRadius = 4
    }
    
}

class SurveyInfoTitleView: UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = Color.CO2.getColor()
        layer.cornerRadius = 18
    }
    
}

class SurveyInfoView: UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
    }
    
}
