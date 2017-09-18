//
//  AskInfoView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 9. 18..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class AskInfoView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let titleLabel = UILabel.init(frame: CGRect.init(x: 16, y: 14, width: cell.frame.width, height: 24))
        let subLabel = UILabel.init(frame: CGRect.init(x: 16, y: 38, width: cell.frame.width, height: 18))
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        subLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.text = "hello world"
        subLabel.text = "nice to meet you"
        
        cell.addSubview(titleLabel)
        cell.addSubview(subLabel)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
