//
//  myPageView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 7. 27..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class myPageView: UIViewController {

    @IBOutlet weak var studyText: UILabel!
    
    @IBOutlet weak var stayText: UILabel!
    
    @IBOutlet weak var positivePointText: UILabel!
    
    @IBOutlet weak var negativePointText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    let studyRoomString = ["가온실","나온실","다온실","라온실","3층 독서실","4층 독서실","열린교실"]
    let stayString = ["금요귀가","토요귀가","토요귀사","잔류"]
    
    override func viewWillAppear(_ animated: Bool) {
        ap.getAPI(add: "apply/extension", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                DispatchQueue.main.async {
                    if res?.statusCode == 204{
                        self.studyText.text = "신청없음"
                    }else if res?.statusCode == 200{
                        let temp = data as! [String:Any]
                        print(temp)
                        self.stayText.text = self.studyRoomString[(temp["class"] as! Int) - 1]
                    }else{
                        self.studyText.text = "로그인 필요"
                    }
                }
            }
        })
        
        ap.getAPI(add: "apply/stay", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                DispatchQueue.main.async {
                    if res?.statusCode == 204{
                        self.studyText.text = "신청없음"
                    }else if res?.statusCode == 200{
                        let temp = data as! [String:Any]
                        print(temp)
                        self.stayText.text = self.stayString[(data as! [String : Int])["value"]! - 1]
                    }else{
                        self.studyText.text = "로그인 필요"
                    }
                }
            }
        })
        
        
    }

}
