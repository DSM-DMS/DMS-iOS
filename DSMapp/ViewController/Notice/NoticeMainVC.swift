//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class NoticeMainVC: UIViewController {

    @IBOutlet weak var notice1Button: UIButton!
    @IBOutlet weak var notice2Button: UIButton!
    @IBOutlet weak var notice3Button: UIButton!
    @IBOutlet weak var notice4Button: UIButton!
    
    private var buttonIdDic: [UIButton : Int]!
    
    override func viewDidLoad() {
        view.backgroundColor = Color.CO6.getColor()
        buttonIdDic = [notice1Button : 0, notice2Button : 1, notice3Button : 2, notice4Button : 3]
        
        for button in buttonIdDic.keys{
            button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        }
    }
    
    @objc func onClick(_ button: UIButton){
        if Token.instance.get() == nil { showToast(msg: "로그인이 필요합니다"); return }
        let value = buttonIdDic[button]!
        if value == 3{ getFacilityViewController() }
        else{
            let listView = self.storyboard?.instantiateViewController(withIdentifier: "NoticeListView") as! NoticeListVC
            listView.id = value
            present(listView, animated: true, completion: nil)
        }
    }
    
    private func getFacilityViewController(){
        let facilityView = storyboard?.instantiateViewController(withIdentifier: "FacilityView") as! FacilityVC
        facilityView.removeFunc = {
            UIView.animate(withDuration: 0.2, animations: { facilityView.view.alpha = 0.0 }, completion: { _ in facilityView.view.removeFromSuperview() })
        }
        view.addSubview(facilityView.view)
        facilityView.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: { facilityView.view.alpha = 1.0 })
    }

}
