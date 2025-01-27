//
//  PostMainVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

final class PostMainVC: UIViewController {
    
    private let postMainView = PostMainView()
    
    override func loadView() {
        self.view = postMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNaviBar()
        postMainView.collectionView.dataSource = self
        postMainView.collectionView.delegate = self
        /// TODO - 셀 : 메인뷰 셀 등록하기,
        /// 셀 클릭 시 화면이동 -> 게시글 상세화면
        /// 글쓰기 버튼 -> 게시글 작성뷰
        /// 구인/구직 두개로 나눠야함, 파일명
    }
    
    // 네비바 생성 및 설정
    private func setUpNaviBar() {
        title = "ㅇㅇ게시판"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .brownText
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "글쓰기", style: .plain, target: self, action: #selector(createPostButtonTapped))
    }
    
    // 네비바 글쓰기 버튼 클릭 시 해당 게시판의 글작성뷰로 이동
    @objc private func createPostButtonTapped() {
        
        let postUploadVC = PostUploadVC()
        
        navigationController?.pushViewController(postUploadVC, animated: true)
    }
}

extension PostMainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// TODO - Rx 적용, 서버로 부터 데이터 받아오기 (몇개까지 받아올지, 페이징처리 할지 고민)
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }

        /// TODO - Rx 적용, 서버에서 받아온 데이터로 셀 적용
        cell.configure(
            with: "제목 \(indexPath.row + 1)",
            detail: " 내용 \(indexPath.row + 1)",
            date: "2025.01.0\(indexPath.row % 9 + 1)",
            tags: ["태그1", "태그2"]
        )
        return cell
    }
}

extension PostMainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let postDetailVC = PostDetailVC()
        /// 서버로 부터 받아온 데이터 같이 넘기기 (Rx적용)
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
