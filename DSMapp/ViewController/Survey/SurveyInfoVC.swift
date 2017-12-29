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
    
    @IBAction func next(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionListTable.dataSource = self
    }

}

extension SurveyInfoVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyInfoCell", for: indexPath) as! SurveyInfoCell
        cell.contentLabel.text = "\(indexPath.row) 번째 입니다."
        return cell
    }
    
}

class SurveyInfoCell: UITableViewCell{
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
