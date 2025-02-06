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
    
    // MARK: - UI 요소들
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
        $0.searchBarStyle = .default
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.cornerRadius = 8
        $0.searchTextField.backgroundColor = .white
        $0.overrideUserInterfaceStyle = .light
        $0.clipsToBounds = true
    }
    
    // MARK: 테두리 주기
    private let devBtn = UIButton(type: .system).then {
        $0.setTitle("Dev", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Gemini Moon", size: 30)
        $0.layer.borderWidth = 1.5 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primary.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 10 // 둥근 모서리 설정 (선택 사항)
        
        $0.addTarget(self, action: #selector(devBtnTapped), for: .touchUpInside)
    }
    private let designBtn = UIButton(type: .system).then {
        $0.setTitle("Design", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Gemini Moon", size: 25)
        $0.layer.borderWidth = 1.5 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primary.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 10 // 둥근 모서리 설정 (선택 사항)
        
        $0.addTarget(self, action: #selector(designBtnTapped), for: .touchUpInside)
    }
    private let pmBtn = UIButton(type: .system).then {
        $0.setTitle("PM", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Gemini Moon", size: 30)
        $0.layer.borderWidth = 1.5 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primary.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 10 // 둥근 모서리 설정 (선택 사항)
        
        $0.addTarget(self, action: #selector(pmBtnTapped), for: .touchUpInside)
    }
    private let etcBtn = UIButton(type: .system).then {
        $0.setTitle("ETC", for: .normal)
        $0.setTitleColor(.primary, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Gemini Moon", size: 30)
        $0.layer.borderWidth = 1.5 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primary.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 10 // 둥근 모서리 설정 (선택 사항)
        
        $0.addTarget(self, action: #selector(etcBtnTapped), for: .touchUpInside)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [devBtn, designBtn, pmBtn, etcBtn]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let latestRecruit = UILabel().then {
        $0.text = "최근 팀원 모집"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout() // 컴포지셔널 레이아웃 생성
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        return collectionView
    }()
    
    var recruitPosts: [Post] = []
    var joinPosts: [Post] = []
    
    let recruitPostType: PostType = .recruitMember
    let joinPostType: PostType = .joinTeam
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        configureUI()
        
        searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLatestPost()
    }
    
    // MARK: - Navigation Bar 설정
    private func navigationBar() {
        let logo = UILabel().then {
            $0.text = "Ting"
            $0.font = UIFont(name: "Gemini Moon", size: 50)
            $0.textColor = .primary
        }
        
        let barItem = UIBarButtonItem(customView: logo)
        navigationItem.leftBarButtonItem = barItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - UI 구성
    private func configureUI() {
        view.backgroundColor = .background
        
        view.addSubviews(searchBar, stackView, collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.height.equalTo((view.bounds.width - 32 - 24) / 4) // 정사각형되도록
        }
        
        // 각 버튼이 정사각형이 되도록 제약 추가
        for button in stackView.arrangedSubviews {
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - 컴포지셔널 레이아웃 생성
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            // 아이템 크기
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(190)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            
            // 그룹 크기
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(190)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            
            // 헤더 사이즈 설정
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .continuous // 수평 스크롤
            
            return section
        }
        return layout
    }
    
    private func fetchLatestPost() {
        let firstType: PostType = .recruitMember
        let secondType: PostType = .joinTeam
        
        // "팀원 모집" Read
        PostService.shared.getLatestPost(type: firstType.rawValue) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.recruitPosts = posts
                self?.collectionView.reloadData()
                
            case .failure(let error):
                self?.basicAlert(title: "서버 오류", message: "\(error.localizedDescription)")
            }
        }
        
        // "팀 합류" Read
        PostService.shared.getLatestPost(type: secondType.rawValue) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.joinPosts = posts
                self?.collectionView.reloadData()
                
            case .failure(let error):
                self?.basicAlert(title: "서버 오류", message: "\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Button Actions
    @objc
    private func devBtnTapped() {
        let list = PostListVC(type: nil, category: "개발자")
        navigationController?.pushViewController(list, animated: true)
    }
    @objc
    private func designBtnTapped() {
        let list = PostListVC(type: nil, category: "디자이너")
        navigationController?.pushViewController(list, animated: true)
    }
    @objc
    private func pmBtnTapped() {
        let list = PostListVC(type: nil, category: "기획자")
        navigationController?.pushViewController(list, animated: true)
    }
    @objc
    private func etcBtnTapped() {
        let list = PostListVC(type: nil, category: "기타")
        navigationController?.pushViewController(list, animated: true)
    }
    
    // MARK: SearchBar 클릭시 동작
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}

// MARK: - 컬렉션뷰 세팅

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 두 개의 섹션
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recruitPosts.count // 첫 번째 섹션: recruitPosts
        } else {
            return joinPosts.count // 두 번째 섹션: joinPosts
        }
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }
        
        var post: Post
        
        if indexPath.section == 0 {
            post = recruitPosts[indexPath.row] // 첫 번째 섹션
        } else {
            post = joinPosts[indexPath.row] // 두 번째 섹션
        }
        
        let date = post.createdAt
        let formattedDate = DateFormatter.postDateFormatter.string(from: date)
        
        cell.configure(
            with: post.title,
            detail: post.detail,
            nickName: post.nickName,
            date: formattedDate,
            tags: post.position
        )
        
        return cell
    }
    
    // MARK: - 섹션 헤더 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        
        header.titleLabel.text = indexPath.section == 0 ? "최근 팀원 모집" : "최근 팀 합류"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var post: Post
        
        if indexPath.section == 0 {
            post = recruitPosts[indexPath.row] // 첫 번째 섹션
        } else {
            post = joinPosts[indexPath.row] // 두 번째 섹션
        }
        /// post 모델의 postType(문자열) 으로 enum PostType 타입으로 복구
        guard let postType = PostType(rawValue: post.postType) else { return }
        let postDetailVC = PostDetailVC(postType: postType, post: post, currentUserNickname: "")
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
