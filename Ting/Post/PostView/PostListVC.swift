//
//  PostListVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/21/25.
//

import UIKit
import SnapKit

final class PostListVC: UIViewController {
    
    private let postListView = PostListView()
    
    private let postType: PostType
    
    var postList: [Post] = []
    
    init(type: PostType) {
        self.postType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = postListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNaviBar()
        fetchPostData()
        postListView.collectionView.dataSource = self
        postListView.collectionView.delegate = self
    }
    
    // 네비바 생성 및 설정
    private func setUpNaviBar() {
        // postType에 따라 타이틀 변경
        switch postType {
        case .recruitMember:
            title = "팀원 모집"
        case .joinTeam:
            title = "팀 합류"
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "글쓰기", style: .plain, target: self, action: #selector(createPostButtonTapped))
    }
    
    // 네비바 글쓰기 버튼 클릭 시 해당 게시판의 글작성뷰로 이동
    @objc private func createPostButtonTapped() {
        switch postType {
        case .recruitMember:
            // 팀원 모집 글작성 뷰컨
            let uploadVC = RecruitMemberUploadVC()
            navigationController?.pushViewController(uploadVC, animated: true)
            
        case .joinTeam:
            // 팀 합류 글작성 뷰컨
            let uploadVC = JoinTeamUploadVC()
            navigationController?.pushViewController(uploadVC, animated: true)
        }
    }
    
    /// 서버로 부터 데이터 가져오기
    private func fetchPostData() {
        PostService.shared.getPostList(type: postType.rawValue) { [weak self] result in
            switch result {
            case .success(let postList):
                self?.postList = postList
                self?.postListView.collectionView.reloadData()
            case .failure(let error):
                self?.basicAlert(title: "업로드 실패", message: "\(error)")
            }
        }
    }
}

extension PostListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// TODO - Rx 적용, 서버로 부터 데이터 받아오기 (몇개까지 받아올지, 페이징처리 할지 고민)
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 메인뷰 카드모양 재사용
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as? MainViewCell else {
            return UICollectionViewCell()
        }
        let post = postList[indexPath.row]
        let date = post.createdAt
        let formattedDate = DateFormatter.postDateFormatter.string(from: date)
        cell.configure(
            with: post.title,
            detail: post.detail,
            date: formattedDate,
            tags: post.position
        )
        /// TODO - Rx 적용, 서버에서 받아온 데이터로 셀 적용
        return cell
    }
}

extension PostListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// post 모델의 postType(문자열) 으로 enum PostType 타입으로 복구
        guard let postType = PostType(rawValue: postList[indexPath.row].postType) else { return }
        let postDetailVC = PostDetailVC(postType: postType)
        /// 서버로 부터 받아온 데이터 같이 넘기기
        /// post 자체를 넘기는 것이 좋을듯
        /// DetailVC.post = self.postList[indexPath.row]
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
