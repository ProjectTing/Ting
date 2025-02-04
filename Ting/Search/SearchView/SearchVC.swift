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
    
    // MARK: - View Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
    }
    
    // MARK: - 버튼 액션 설정
    private func setupActions() {
        searchView.categorySelectButton.addTarget(self, action: #selector(categorySelectButtonTapped), for: .touchUpInside)
    }
    
    @objc private func categorySelectButtonTapped() {
        let modalVC = SearchSelectModalVC()
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(modalVC, animated: true)
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// TODO - Rx 적용, 서버로 부터 데이터 받아오기 (몇개까지 받아올지, 페이징처리 할지 고민)
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }
        
        /// TODO - Rx 적용 ⭐️ 처음 진입시 검색된 거 0개, 검색 이후 셀 표시
        cell.configure(
            with: "제목 \(indexPath.row + 1)",
            detail: " 내용 \(indexPath.row + 1)",
            date: "2025.01.0\(indexPath.row % 9 + 1)",
            tags: ["태그1", "태그2"]
        )
        return cell
    }
}

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let postDetailVC = PostDetailVC(postType: .findTeam)
        /// 서버로 부터 받아온 데이터 같이 넘기기 (Rx적용)
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
