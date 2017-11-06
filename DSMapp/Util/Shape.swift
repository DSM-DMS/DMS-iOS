//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ButtonShape: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
        
        backgroundColor = Color.MINT.getColor()
        
        tintColor = UIColor.white
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class NavigationShape: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.barTintColor = Color.CO6.getColor()
    }
    
}

class TabShape: UITabBarController {
    
    override func viewDidLoad() {
        tabBar.barTintColor = Color.CO4.getColor()
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
    }
    
}
