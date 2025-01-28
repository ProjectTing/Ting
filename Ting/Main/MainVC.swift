//
//  ViewController.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import SnapKit
import Then

class MainVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    
    // MARK: - UI 요소들
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
    private lazy var stackView = UIStackView(arrangedSubviews: [btn1, btn2, btn3, btn4]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let latestMember = UILabel().then {
        $0.text = "최근 구인 글"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 390, height: 195) // 셀 크기 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
        
        return collectionView
    }()
    
    private let latestProject = UILabel().then {
        $0.text = "최근 구직 글"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    private let collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 390, height: 195) // 셀 크기 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        configureUI()
        
        searchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView2.dataSource = self
        collectionView2.delegate = self
    }
    
    // MARK: - Navigation Bar 설정
    private func navigationBar() {
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
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchLabel.snp.bottom).offset(20)
            $0.height.equalTo(80)
        }
        
        // 최신 구인 글 (latestMember)와 컬렉션 뷰
        view.addSubview(latestMember)
        latestMember.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(latestMember.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        // 최신 구직 글 (latestProject)와 컬렉션 뷰
        view.addSubview(latestProject)
        latestProject.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(collectionView2)
        collectionView2.snp.makeConstraints {
            $0.top.equalTo(latestProject.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
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

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // 카드 개수 (예제 데이터)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }

        // collectionView2는 "최근 구직 글" 관련 데이터 표시
        let titlePrefix = (collectionView == collectionView2) ? "구직" : "구인"

        cell.configure(
            with: "\(titlePrefix) 제목 \(indexPath.row + 1)",
            detail: "\(titlePrefix) 내용 \(indexPath.row + 1)",
            date: "2025.01.0\(indexPath.row % 9 + 1)",
            tags: ["태그1", "태그2"]
        )

        return cell
    }
}
