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
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDevelperText: UITextView!
    
    public var position = 0
    
    let colorArr = [Color.CO1, .CO2, .CO3, .CO4, .CO5]
    
    func setPosition(_ position: Int) -> IntroDeveloperContentVC{
        self.position = position
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = colorArr[position].getColor()
    }
}
