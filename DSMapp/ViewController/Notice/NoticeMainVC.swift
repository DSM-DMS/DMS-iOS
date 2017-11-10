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
    
    override func viewDidLoad() {
        view.backgroundColor = Color.CO6.getColor()
        addAction(notice1Button)
        addAction(notice2Button)
        addAction(notice3Button)
        addAction(notice4Button)
    }
    
    func onClick(_ button: UIButton){
        if notice4Button == button{
            getFacilityViewController()
        }else{
            let noticeListView = storyboard?.instantiateViewController(withIdentifier: "NoticeListView") as! NoticeListVC
            present(noticeListView, animated: true, completion: nil)
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


