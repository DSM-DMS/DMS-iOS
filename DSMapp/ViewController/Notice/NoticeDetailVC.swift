//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NoticeDetailVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var id = 0
    var url = ""
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let imageIdArr = ["ruleIcon","notificationIcon", "questionIcon"]
        logoImageView.image = UIImage.init(named: imageIdArr[id])
        getData()
    }
    
    private func getData(){
        Connector.instance.request(createRequest(sub: url, method: .get, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    let data = try! JSONDecoder().decode(NoticeDetailModel.self, from: data)
                    self.setBind(data)
                }else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    private func setBind(_ data : NoticeDetailModel){
        titleLabel.text = data.title
        webView.loadHTMLString(data.content, baseURL: nil)
    }

}
