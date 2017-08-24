//
//  NoticeListCell.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 24..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class NoticeListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var newImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
