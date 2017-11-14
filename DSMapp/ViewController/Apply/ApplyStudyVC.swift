//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ApplyStudyVC: UIViewController  {

    @IBOutlet weak var contentView: BackViewShape!
    @IBOutlet weak var changeRoomButton: UIButton!
    
    @IBAction func pressBack(_ sender: Any) {
        back()
    }
    
    let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
    
    @IBAction func apply(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        contentView.backgroundColor = Color.CO6.getColor()
        changeRoomButton.addTarget(self, action:
            #selector(changeRoom(_:)), for: .touchUpInside)
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        
    }
    
}

extension ApplyStudyVC{
    
    @objc func changeRoom(_ button: UIButton){
        let alert = UIAlertController(title: "방을 선택하세요.", message: nil, preferredStyle: .actionSheet)
        for i in roomNameArr{
            alert.addAction(UIAlertAction.init(title: i, style: .default, handler: alertClick(_:)))
        }
        alert.addAction(UIAlertAction.init(title: "닫기", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertClick(_ action: UIAlertAction){
        for i in 0..<roomNameArr.count{
            if action.title == roomNameArr[i]{
                changeRoomButton.setTitle(action.title, for: .normal)
                return
            }
        }
    }
}
