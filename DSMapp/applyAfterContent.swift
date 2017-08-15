//
//  applyAfterContent.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class applyAfterContent: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var contentIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let name = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: 200, height: 30))
        name.text = "hello world"
        cell.addSubview(name)
        return cell
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    

    let colorArray = [UIColor.red,UIColor.black,UIColor.blue,UIColor.brown]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTableView.separatorStyle = .none
        answerTableView.dataSource = self
        answerTableView.delegate = self
    }
    
    var beforeIndexPath : IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if beforeIndexPath != nil{
            tableView.cellForRow(at: beforeIndexPath!)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        beforeIndexPath = indexPath
    }
    
    func changeBack(){
        view.backgroundColor = colorArray[contentIndex]
    }
}
