//
//  NoticeListView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 24..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class NoticeListView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let ap = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    let urlStr = ["rule","notice,","faq"]
    let titleStr = ["기숙사 규정","공지사항","자주하는 질문"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ap.noticeTitle
        tableView.delegate = self
        tableView.dataSource = self
        var tempNum = 0
        
        
        for i in 0..<titleStr.count{
            if ap.noticeTitle == titleStr[i]{
                tempNum = i
                break;
            }
        }
        
        ap.noticeDataArr = [NoticeData]()
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 16, y: 0, width: 70, height: 70))
        imageView.image = UIImage.init(named: <#T##String#>);

        ap.getAPI(add: "post/list/\(urlStr[tempNum])", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                if res?.statusCode == 200{
                    var noticeDataArr = [NoticeData]()
                    let temp = data as! [String : Any]
                    let num_of_post = temp["num_of_post"]! as! Int
                    var temNoticeDataArr = temp["result"]! as! [[String : Any]]
                    for i in 0..<num_of_post{
                        let tempNoticeData = temNoticeDataArr[i]
                        let no = tempNoticeData["no"] as! Int
                        let title = tempNoticeData["title"] as! String
                        let content = tempNoticeData["content"] as! String
                        noticeDataArr.append(NoticeData.init(content: content, title: title, no: no))
                        print(no, title, content)
                    }
                    DispatchQueue.main.async {
                        self.ap.noticeDataArr = noticeDataArr
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ap.noticeData = ap.noticeDataArr[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoticeDetailView")
        present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! NoticeListCell
        cell.titleLabel.text = ap.noticeDataArr[indexPath.row].title
        //cell.writerLabel.text = "\(ap.noticeDataArr[indexPath.row].no)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ap.noticeDataArr.count
    }
    
}

struct NoticeData {
    var content = ""
    var title = ""
    var no = 0
}
