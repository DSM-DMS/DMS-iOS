//
//  NoticeDetailView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 24..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit


class NoticeDetailView: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var contentView: UIView!
    
    var imageMap = [String : UIImage]()
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.title = ap.noticeTitle
        imageMap["기숙사 규정"] = UIImage.init(named: "ruleIcon")
        imageMap["공지사항"] = UIImage.init(named: "notificationIcon")
        imageMap["자주하는 질문"] = UIImage.init(named: "questionIcon")
        imageView.image = imageMap[ap.noticeTitle]
        
        let view1 = UIView.init(frame: CGRect.init(x: -4, y: contentWebView.frame.maxY - contentWebView.frame.height, width: 8, height: contentWebView.frame.height))
        print(464, contentWebView.frame.height)
        view1.backgroundColor = UIColor.init(red: 178/255, green: 212/255, blue: 230/255, alpha: 1)
        view1.layer.cornerRadius = 4
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        contentView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 5
        contentView.addSubview(view1)
        
        titleLabel.text = ap.noticeData.title
        
        contentWebView.loadHTMLString(ap.noticeData.content, baseURL: nil)
        
        //contentWebView.loadRequest(URLRequest.init(url: URL.init(string: "http://www.naver.com")!))
    }
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
