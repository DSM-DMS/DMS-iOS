//
//  MyPageVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController {

    @IBOutlet weak var stayStateLabel: UILabel!
    @IBOutlet weak var studyStateLabel: UILabel!
    @IBOutlet weak var positiveCountLabel: UILabel!
    @IBOutlet weak var negativeCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        connector(add: "/mypage", method: "GET", params: [:], fun: {
            data, code in
            
            switch code {
            case 200:
                let decoderData = try! JSONDecoder().decode(MyPageModel.self, from: data!)
                self.stayStateLabel.text = "\(self.getStayStateName(decoderData.stay_value))"
                if decoderData.extension_class == nil{
                    self.studyStateLabel.text = "신청없음"
                }else{
                    self.studyStateLabel.text = "\(self.getClassName(decoderData.extension_class!))-\(decoderData.extension_seat!)"
                }
            case 204:
                self.showToast(msg: "로그인이 필요합니다.")
            default:
                self.showToast(msg: "오류가 발생했습니다. : \(code)")
            }
            
        })
    }

}

extension MyPageVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
