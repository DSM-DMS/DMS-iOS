//
//  IntroDeveloperContentVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 28..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class IntroDeveloperContentVC: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    public var position = 0
    
    let titleArr = ["Design", "Mobile", "Web", "Server", "Windows"]
    let contentArr = [[("DMS 총괄 메인 디자이너", "김동규")], [("iOS 메인, Android 메인 개발", "이병찬"), ("Android 메인 개발", "윤정현"), ("Android 서브 개발", "이성현")], [("Web 학생 페이지 개발", "김건"), ("Web 학생 페이지 개발", "서윤호"), ("Web 관리자 페이지 개발", "김형규"), ("Web 관리자 페이지 개발", "오인서"), ("Web 관리자 페이지 개발", "윤효상")], [("DMS 서버 개발", "조민규"), ("DMS 서버 개발", "인상민")], [("관리자 App 메인 개발", "김동현"), ("관리자 App 서브 개발", "이종현"), ("급식 위젯 개발, 영상 제작", "류근찬")]]
    
    func setPosition(_ position: Int) -> IntroDeveloperContentVC{
        self.position = position
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTitleLabel.text = titleArr[position]
        contentTitleLabel.textColor = position % 2 == 1 ? UIColor.white : UIColor.black
        backImage.image = UIImage.init(named: "intro_back_\(position % 2 + 1)")
        contentImage.image = UIImage.init(named: "intro_icon_\(position)")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension IntroDeveloperContentVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr[position].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let data = contentArr[position][row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(row % 2 == 0 ? "Left" : "Right")DevelopCell", for: indexPath) as! DevelopCell
        cell.baseImage.image = UIImage.init(named: "intro_icon_\(position)")
        cell.titleLabel.text = data.0
        cell.subLabel.text = data.1
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

class DevelopCell: UITableViewCell{
    
    @IBOutlet weak var baseImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
}
