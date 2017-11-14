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
    
    var buttonArr = [UIButton]()
    
    override func viewDidLoad() {
        view.backgroundColor = Color.CO6.getColor()
        buttonArr = [notice1Button, notice2Button, notice3Button, notice4Button]
        
        for i in buttonArr{
            i.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        }
    }
    
    @objc func onClick(_ button: UIButton){
        if notice4Button == button{
            getFacilityViewController()
        }else{
            for i in 0..<buttonArr.count - 1{
                if buttonArr[i] == button{
                    let listView = self.storyboard?.instantiateViewController(withIdentifier: "NoticeListView") as! NoticeListVC
                    listView.id = i
                    present(listView, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    func getFacilityViewController(){
        let facilityView = storyboard?.instantiateViewController(withIdentifier: "FacilityView") as! FacilityVC
        facilityView.removeFunc = {
            facilityView.view.removeFromSuperview()
        }
        view.addSubview(facilityView.view)
    }
    
    func addAction(_ button: UIButton){
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }

}


