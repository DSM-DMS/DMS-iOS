//
//  applyAfterContent.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class ApplyAfterContent: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var contentIndex = 0
    var data = [String]()
    var name = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = UILabel.init(frame: CGRect.init(x: 30, y: 5, width: 200, height: 30))
        name.text = data[indexPath.row]
        cell.addSubview(name)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = name
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.selectRow(at: checkIndexPath, animated: true, scrollPosition: .none)
    }
    
    var checkIndexPath : IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkIndexPath != nil{
            tableView.cellForRow(at: checkIndexPath!)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        checkIndexPath = indexPath
    }
}
