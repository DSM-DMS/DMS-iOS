//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class NoticeDetailVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var id = 0
    var url = ""
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let imageIdArr = ["ruleIcon","notificationIcon", "questionIcon"]
        logoImageView.image = UIImage.init(named: imageIdArr[id])
        
        bind()
    }
    
    func bind(){
        connector(add: url, method: "GET", params: [:], fun: {
            data, code in
            if code == 200{
                let setData = try! JSONDecoder().decode(NoticeDetailModel.self, from: data!)
                self.titleLabel.text = setData.title
                self.webView.loadHTMLString(setData.content, baseURL: nil)
            }else{
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }

}
