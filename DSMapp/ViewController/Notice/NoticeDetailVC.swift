//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class NoticeDetailVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var sideView: BackViewShape!
    
    override func viewDidLoad() {
        webView.loadRequest(URLRequest.init(url: URL(string: "http://www.naver.com")!))
        sideView.backgroundColor = Color.MINT.getColor()
    }

}
