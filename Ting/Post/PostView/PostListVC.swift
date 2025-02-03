//
//  PostListVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
    
    var uploadVC: UIViewController {
        switch self {
        case .findMember: return FindMemberUploadVC()
        case .findTeam: return FindTeamUploadVC()
        }
    }
}

final class PostListVC: UIViewController {
    
    private let postListView = PostListView()
    private let viewModel: PostListVM
    private let disposeBag = DisposeBag()
    
    init(type: PostType) {
        self.viewModel = PostListVM(type: type)
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
        setupNaviBar()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// TODO - 서버비용 아끼기 위한 방법 고민
        viewModel.fetchPosts()
    }
    
    private func bindUI() {
        // CollectionView 바인딩
        viewModel.posts
            .asDriver(onErrorDriveWith: .empty())
            .drive(postListView.collectionView.rx.items(
                cellIdentifier: MainViewCell.identifier,
                cellType: MainViewCell.self
            )) { index, post, cell in
                let formattedDate = DateFormatter.postDateFormatter.string(from: post.createdAt)
                cell.configure(
                    with: post.title,
                    detail: post.detail,
                    date: formattedDate,
                    tags: post.position
                )
            }
            .disposed(by: disposeBag)
        
        // 셀 선택 바인딩
        postListView.collectionView.rx.modelSelected(Post.self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] post in
                self?.viewModel.modelSelected.accept(post)
                let detailVC = PostDetailVC()
                /// DetailVM에 포스트 전달 -> VM 으로 VC 생성 후 이동
                /// let detailVM = PostDetailVM(post: post)
                /// let detailVC = PostDetailVC(viewModel: detailVM)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNaviBar() {
        title = viewModel.postType.title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let writeButton = UIBarButtonItem(title: "글쓰기")
        
        writeButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                // 뷰모델의 포스트 타입에 따라감
                if let uploadVC = self?.viewModel.postType.uploadVC {
                    self?.navigationController?.pushViewController(uploadVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = writeButton
    }
}
