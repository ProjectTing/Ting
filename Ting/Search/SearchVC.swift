//
//  SearchVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit

class SearchVC: UIViewController {

    // MARK: UI요소들
    let logo = UILabel().then {
        $0.text = "TING"
        $0.font = UIFont(name: "Gemini Moon", size: 50)
        $0.textColor = UIColor(hexCode: "C2410C")
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logo)
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
    
}
