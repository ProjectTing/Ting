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

    let cell = MainViewCell()
    
    // MARK: - UI요소들
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
        $0.searchBarStyle = .minimal
        $0.backgroundImage = UIImage()
    }
    private let searchLabel = UILabel().then {
        $0.text = "원하는 프로젝트를 검색해보세요."
        $0.textAlignment = .left
        $0.textColor = .black
    }
    private let btn1 = UIButton(type: .system).then {
        $0.setTitle("앱", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
    }
    private let btn2 = UIButton(type: .system).then {
        $0.setTitle("웹", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
    }
    private let btn3 = UIButton(type: .system).then {
        $0.setTitle("디자이너", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
    }
    private let btn4 = UIButton(type: .system).then {
        $0.setTitle("기획자", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
    }
    private let latestTeamMateLabel = UILabel()

    //let stackView = UIStackView() // 플로우 레이아웃, 컴포지셔널 레이아웃
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        configureUI()
        stackView()
        searchBar.delegate = self // 서치바 delegate 설정
    }
    
    // MARK: - Custom Navigation Bar
    func navigationBar() {
        
        // 커스텀 UILabel을 만들어서 왼쪽 아이템에 넣음
        let logo = UILabel().then {
            $0.text = "Ting"
            $0.font = UIFont(name: "Gemini Moon", size: 50)
            $0.textColor = UIColor(hexCode: "C2410C")
        }
        
        let barItem = UIBarButtonItem(customView: logo)
        navigationItem.leftBarButtonItem = barItem
    }
    
    // MARK: - UI 구성
    private func configureUI() {
        view.backgroundColor = UIColor(hexCode: "FFF7ED")
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        view.addSubview(searchLabel)
        searchLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        
    }
    
    // MARK: - StackView
    private func stackView() {
        let stackView = UIStackView(arrangedSubviews: [btn1, btn2, btn3, btn4]).then { // 플로우 레이아웃, 컴포지셔널 레이아웃
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchLabel.snp.bottom).offset(30)
            $0.height.equalTo(80)
        }
        
        
    }
    
    // MARK: - 서치바 클릭시 동작
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        print("검색버튼 클릭 됨 | 이동완료")
        return false
    }
    
}



// MARK: - extensions


@available(iOS 17.0, *)
#Preview {
    MainVC()
}
