//
//  ViewController.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import SnapKit
import Then

class MainVC: UIViewController, UISearchBarDelegate {

    // MARK: UI요소들
    let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
        $0.searchBarStyle = .minimal
        $0.backgroundImage = UIImage()
    }
    let stackView = UIStackView()
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        configureUI()
        searchBar.delegate = self // 서치바 delegate 설정
    }
    
    // MARK: Custom Navigation Bar
    func navigationBar() {
        
        self.title = ""
        // 기본 타이틀을 빈 문자열로 설정하여 기본 타이틀 숨기기
        // 그리고 커스텀 UILabel을 만들어서 왼쪽 아이템에 넣음
        
        let logo = UILabel().then {
            $0.text = "Ting"
            $0.font = UIFont(name: "Gemini Moon", size: 50)
            $0.textColor = UIColor(hexCode: "C2410C")
        }
        
        let barItem = UIBarButtonItem(customView: logo)
        navigationItem.leftBarButtonItem = barItem
    }
    
    // MARK: UI 구성
    func configureUI() {
        view.backgroundColor = UIColor(hexCode: "FFF7ED")
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
    }
    
    // MARK: 서치바 클릭시 동작
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        print("검색버튼 클릭 됨 | 이동완료")
        return false
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

