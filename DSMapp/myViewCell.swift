//
//  myViewCell.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 7. 27..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class myViewCell{
    
    let cell = UITableViewCell()
    
    init(text : String) {
        let label = UILabel.init(frame: CGRect.init(x: 35, y: 15, width: 150, height: 25))
        label.text = text
        label.font = UIFont.init(name: "System", size: 18)
        cell.accessoryType = .disclosureIndicator
        cell.addSubview(label)
    }

    func getCell() -> UITableViewCell{
        return cell
    }
}
