//
//  PostListVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/21/25.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class PostListVC: UIViewController {
    
    private let postListView = PostListView()
    
    private let postType: PostType
    
    var postList: [Post] = []
    private var lastDocument: DocumentSnapshot? // 현재 페이지의 마지막 문서
    private var isLoading = false // 로딩 중 여부 체크
    private var hasMoreData = true
    
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
        loadInitialData()
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
    
    // MARK: - 초기 데이터 로드
    private func loadInitialData() {
        guard hasMoreData else { return }
        isLoading = true
        
        PostService.shared.getPostList(type: postType.rawValue, lastDocument: nil) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let newPosts, let lastDocument)):
                self.postList = newPosts
                self.lastDocument = lastDocument
            case .failure(let error):
                self.basicAlert(title: "서버 에러", message: "\(error.localizedDescription)")
            }
            
            self.isLoading = false
            self.postListView.collectionView.reloadData()
        }
        
    }
    
    // MARK: - 다음 페이지 로드
    private func loadNextPage() {
        guard hasMoreData, !isLoading, let lastDocument = lastDocument else { return }
        isLoading = true
        postListView.collectionView.reloadData()
        
        PostService.shared.getPostList(type: postType.rawValue, lastDocument: lastDocument) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let newPosts, let nextLastDocument)):
                self.postList += newPosts
                self.lastDocument = nextLastDocument
                self.hasMoreData = newPosts.count == 20
            case .failure(let error):
                self.basicAlert(title: "서버 에러", message: "\(error.localizedDescription)")
            }
            
            self.isLoading = false
            self.postListView.collectionView.reloadData()
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
    
    // 푸터 인디케이터뷰 등록
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.id,
                for: indexPath) as? LoadingFooterView else {
                return UICollectionReusableView()
            }
            return footer
        }
        return UICollectionReusableView()
    }
    
    // 푸터 보이기직전 실행
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter,
           let footer = view as? LoadingFooterView {
            if isLoading {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
        }
    }
}

extension PostListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        /// post 모델의 postType(문자열) 으로 enum PostType 타입으로 복구
        guard let postType = PostType(rawValue: postList[indexPath.row].postType) else { return }
        let postDetailVC = PostDetailVC(postType: postType, post: post)
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    // 불러온 갯수 - 5번째의 셀 보여질때 loadNextPage 실행
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == postList.count - 5 {
            loadNextPage()
        }
    }
}

// 인디케이터 푸터 동적 크기 설정
extension PostListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return isLoading ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
}

///TODO - 작성하기 눌렀을 때 ViewWillDisAppear에서 delegate로 fetch
/// prefetchItemAt 알아보고 적용해보기
/// hasMoreData, reload 관련 코드 수정 필요
