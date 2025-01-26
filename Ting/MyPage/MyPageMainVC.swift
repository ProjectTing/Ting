//
//  MyPageMainVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then

class MyPageMainVC: UIViewController {
    
    private let btn2 = UIButton(type: .system).then {
        $0.setTitle("웹", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(btn2)
        btn2.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
}

