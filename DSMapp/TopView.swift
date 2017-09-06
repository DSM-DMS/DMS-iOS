//
//  TopView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 9. 5..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class TopView: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.init(red: 219/255, green: 234/255, blue: 242/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
