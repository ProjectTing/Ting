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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.cornerRadius = 8
        $0.searchTextField.backgroundColor = .white
        $0.overrideUserInterfaceStyle = .light
        $0.clipsToBounds = true
        $0.searchTextField.clipsToBounds = true
    }
    
    // 카테고리 선택 버튼
    let categorySelectButton = UIButton(type: .system).then {
        $0.setTitle("검색필터", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        $0.tintColor = .deepCocoa
    }
    
    let scrollView = UIScrollView().then {
        $0.alwaysBounceHorizontal = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    let contentView = UIView()
    
    // 카테고리 선택 후 생김
    lazy var selectedCategoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    // 검색 결과 리스트 표시
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        /// TODO - 게시글 리스트와 마찬가지로 메인뷰 셀 모양 조정에 따라 변경 필요
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
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
        self.backgroundColor = .background
        
        scrollView.addSubview(contentView)
        contentView.addSubview(selectedCategoryStackView)
        addSubviews(
            searchBar,
            categorySelectButton,
            scrollView,
            collectionView
        )
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        categorySelectButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(65)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.equalTo(categorySelectButton.snp.trailing).offset(8)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.centerY.equalTo(categorySelectButton)
            $0.height.equalTo(categorySelectButton)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide)
            $0.width.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        selectedCategoryStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(categorySelectButton.snp.bottom).offset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}
