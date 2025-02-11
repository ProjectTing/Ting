//
//  SearchVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit

/// 검색 및 카테고리 모달을 관리하는 뷰컨트롤러
final class SearchVC: UIViewController {
    
    // 검색 뷰
    private let searchView = SearchView()
    
    // 모달에서 선택된 태그들을 저장하는 변수
    private var selectedTags: [String] = []
    
    // 검색 결과를 담을 posts 배열 (실제 데이터 모델에 맞게 변경)
    private var postList: [Post] = []
    
    // MARK: - View Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupActions()
    }
    
    private func setup() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        searchView.searchBar.delegate = self
        searchView.searchBar.becomeFirstResponder()
        setupTapGesture()
    }
    
    // MARK: - 버튼 액션 설정
    private func setupActions() {
        searchView.categorySelectButton.addTarget(self, action: #selector(categorySelectButtonTapped), for: .touchUpInside)
    }
    
    @objc private func categorySelectButtonTapped() {
        let modalVC = SearchSelectModalVC()
        
        // SearchVC를 델리게이트로 지정
        modalVC.delegate = self
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(modalVC, animated: true)
    }
    
    // 검색 API 호출 예시 (Firestore 쿼리)
    private func searchPosts(with searchText: String) {
        PostService.shared.searchPosts(searchText: searchText, selectedTags: selectedTags) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.postList = posts
                self?.searchView.collectionView.reloadData()
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    /// 키보드 내리기
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        searchView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchView.endEditing(true)
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// TODO - Rx 적용, 서버로 부터 데이터 받아오기 (몇개까지 받아올지, 페이징처리 할지 고민)
        postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }
        
        /// TODO - Rx 적용 ⭐️ 처음 진입시 검색된 거 0개, 검색 이후 셀 표시
        let post = postList[indexPath.row]
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
}

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        /// post 모델의 postType(문자열) 으로 enum PostType 타입으로 복구
        guard let postType = PostType(rawValue: postList[indexPath.row].postType) else { return }
        let postDetailVC = PostDetailVC(postType: postType, post: post, currentUserNickname: "")
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

// MARK: - SearchSelectModalDelegate

extension SearchVC: SearchSelectModalDelegate {
    func didApplyFilter(with selectedTags: [String]) {
        // SearchVC에 선택된 태그 저장
        self.selectedTags = selectedTags
        
        // 기존의 태그 버튼들 제거
        searchView.selectedCategoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 선택한 태그들로 라벨 생성, stackView에 추가
        selectedTags.forEach { tag in
            let label = PaddingLabel().then {
                $0.text = tag
                $0.font = .systemFont(ofSize: 16, weight: .medium)
                $0.textColor = .primary
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 6
                $0.layer.borderWidth = 0.8
                $0.layer.borderColor = UIColor.secondary.cgColor
                $0.textAlignment = .center
                $0.clipsToBounds = true
                $0.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            }
            
            searchView.selectedCategoryStackView.addArrangedSubview(label)
            label.snp.makeConstraints {
                $0.height.equalTo(30)
                $0.centerY.equalToSuperview()
            }
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색어 가져오기
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        // 키보드 내리기
        searchBar.resignFirstResponder()
        // 검색 메서드 호출
        searchPosts(with: searchText)
    }
}
