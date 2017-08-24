//
//  NoticeDetailView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 24..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class NoticeDetailView: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var contentView: UIView!
    
    var imageMap : [String : UIImage]?
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageMap?["기숙사 규정"] = UIImage.init(named: "ruleIcon")
        imageMap?["공지사항"] = UIImage.init(named: "notificationIcon")
        imageMap?["자주하는 질문"] = UIImage.init(named: "questionIcon")
        imageView.image = imageMap?[ap.noticeTitle] 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
