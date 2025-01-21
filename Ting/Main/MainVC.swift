//
//  ViewController.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import SnapKit
import Then

class MainVC: UIViewController {

    // MARK: UI요소들
    let logo = UILabel().then {
        $0.text = "TING"
        $0.font = UIFont(name: "Gemini Moon", size: 50)
        $0.textColor = UIColor(hexCode: "C2410C")
    }
    let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
        $0.searchBarStyle = UISearchBar.Style.default
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: UI 구성
    func configureUI() {
        view.backgroundColor = UIColor(hexCode: "FFF7ED")
        
        view.addSubview(logo)
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(logo.snp.top).offset(10)
            $0.center.equalToSuperview()
        }
    }
    
}




// MARK: extensions
// RGB를 Hex Color로 변환
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

