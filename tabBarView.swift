//
//  tabBarView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class tabBarView: UITabBarController {

    override func viewDidLoad() {
        tabBar.barTintColor = UIColor.init(red: 167/255, green: 201/255, blue: 218/255, alpha: 1)
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
    }

}
