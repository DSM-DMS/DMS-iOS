//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ButtonShape: UIButton {
    
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.cornerRadius = frame.height / 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
        backgroundColor = Color.MINT.getColor()
        tintColor = UIColor.white
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
}

class ToolBarShape: UIToolbar{
    
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        setShadowImage(UIImage(), forToolbarPosition: .top)
        setShadowImage(UIImage(), forToolbarPosition: .bottom)
    }
    
}

class SurveyButtonShape: UIButton {
    
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.cornerRadius = 32
        backgroundColor = Color.CO3.getColor()
        tintColor = UIColor.white
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
}

class BackViewShape: UIView{
    
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.init(width: 1, height: 1)
    }
    
}

class NavigationShape: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.barTintColor = Color.CO6.getColor()
        navigationBar.backItem?.titleView?.tintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
    }

}

class BackApplyContentView: UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 16
        backgroundColor = UIColor.white
    }
    
}

class TabShape: UITabBarController {
    
    override func viewDidLoad() {
        tabBar.barTintColor = Color.CO4.getColor()
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
    }
    
}
