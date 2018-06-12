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
    
    var id = 0
    var postID = ""
    
    @IBAction func back(_ sender: Any) {
        self.goBack()
    }
    
    override func viewDidLoad() {
        logoImageView.image = UIImage.init(named: NoticeUtil.detailImageIdArr[id])
        getData()
    }
    
    private func getData(){
        _ = Connector.instance
                .getRequest(NoticeAPI.getNoticeContent(category: NoticeUtil.urlArr[id], postID: postID), method: .get)
                .decodeData(NoticeDetailModel.self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                guard let strongSelf = self else { return }
                if code == 200{ strongSelf.setBind(data!) }
                else { strongSelf.showError(code) }
            })
    }
    
    private func setBind(_ data : NoticeDetailModel){
        titleLabel.text = data.title
        webView.loadHTMLString(data.content, baseURL: nil)
    }

}
