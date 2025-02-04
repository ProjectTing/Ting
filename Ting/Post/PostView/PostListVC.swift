//
//  PostListVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/21/25.
//

import UIKit
import SnapKit

/// TODO - 게시판 명칭 정리해야함,
/// 메인에서 앱,웹,디자이너,기획자 눌렀을때는 어떻게 할지 고민
// 게시판 타입에 따라 분기처리
enum PostType {
    case findMember
    case findTeam
    
    var title: String {
        switch self {
        case .findMember: return "팀원구함"
        case .findTeam: return "팀구함"
        }
    }
}

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
        postListView.collectionView.dataSource = self
        postListView.collectionView.delegate = self
        
        /// TODO - 서버로 부터 데이터 가져오기
        /// 테스트 끝나고 ViewWillAppear로 옮겨야함
        PostService.shared.getPostList(type: postType.title) { [weak self] result in
            switch result {
            case .success(let postList):
                self?.postList = postList
                DispatchQueue.main.async {
                    self?.postListView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 네비바 생성 및 설정
    private func setUpNaviBar() {
        
        switch postType {
        case .findMember:
            title = "팀원구함"
        case .findTeam:
            title = "팀구함"
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
        case .findMember:
            // 구인 글작성 뷰컨
            let uploadVC = FindMemberUploadVC()
            navigationController?.pushViewController(uploadVC, animated: true)
            
        case .findTeam:
            // 구직 글작성 뷰컨
            let uploadVC = FindTeamUploadVC()
            navigationController?.pushViewController(uploadVC, animated: true)
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
        
        let postDetailVC = PostDetailVC()
        /// 서버로 부터 받아온 데이터 같이 넘기기 (Rx적용)
        /// DetailVC.post = self.postList[indexPath.row]
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
