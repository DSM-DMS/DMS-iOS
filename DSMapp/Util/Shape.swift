//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        tabBar.barTintColor = Color.CO4.getColor()
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        getAccessToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        versionCheck("1.0.7")
    }
    
    private func getAccessToken(){
        if Token.instance.get() == nil { return }
        
        var request = Connector.instance
            .getRequest(AuthAPI.refreshAccessToken, method: .get)
            
        _ = request.setRefreshToken()
            .decodeData(AuthModel.self, vc: self)
            .subscribe(onNext: { [weak self] code, data in
                guard let strongSelf = self else { return }
                let token = Token.instance
                if code == 200 { token.changeAccessToken(data!.accessToken) }
                else if (code == 205) || (401 == code) { token.remove(); strongSelf.showToast(msg: "다시 로그인 해주세요.") }
                else{ strongSelf.showError(code) }
            })
    }
    
}
