//
//  IntroDeveloperContentVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 12. 28..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class IntroDeveloperContentVC: UIViewController {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDevelperText: UITextView!
    
    public var position = 0
    
    let colorArr = [UIColor.init(red: 240/255, green: 67/255, blue: 58/255, alpha: 1), UIColor.init(red: 239/255, green: 93/255, blue: 53/255, alpha: 1), UIColor.init(red: 1, green: 223/255, blue: 79/255, alpha: 1), UIColor.init(red: 118/255, green: 191/255, blue: 114/255, alpha: 1), UIColor.init(red: 31/255, green: 156/255, blue: 139/255, alpha: 1)]
    
    
    func setPosition(_ position: Int) -> IntroDeveloperContentVC{
        self.position = position
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = colorArr[position]
        contentImage.image = UIImage.init(named: "dev_\(position + 1)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
}
