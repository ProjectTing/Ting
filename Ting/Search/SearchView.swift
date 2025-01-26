//
//  SearchView.swift
//  Ting
//
//  Created by Sol on 1/22/25.
//

import UIKit
import SnapKit
import Then

/// 검색 화면 UI를 담당하는 뷰
final class SearchView: UIView {
    
    // 🔍 검색창
    let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .default
        $0.backgroundColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.cornerRadius = 8
    }
    
    // 카테고리 선택 버튼
    let categorySelectButton = UIButton(type: .system).then {
        $0.setTitle("필터설정", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        $0.tintColor = .deepCocoa
    }
    
    // 카테고리 선택 후 생김
    lazy var selectedCategoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    // 검색 결과 리스트 표시
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.id)
        collectionView.backgroundColor = .background
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        backgroundColor = .background
        [
            searchBar,
            categorySelectButton,
            selectedCategoryStackView,
            collectionView
        ].forEach { addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        categorySelectButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(4)
            $0.leading.equalTo(searchBar.snp.leading).offset(4)
        }
        
        selectedCategoryStackView.snp.makeConstraints {
            $0.centerY.equalTo(categorySelectButton)
            $0.leading.equalTo(categorySelectButton.snp.trailing).offset(8)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(categorySelectButton.snp.bottom).offset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}
