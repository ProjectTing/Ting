//
//  TestPostVC.swift
//  Ting
//
//  Created by 유태호 on 1/22/25.
//

/**
 파이어베이스 - 프로젝트 연결간 테스트을 위한 폴더인 TestFile과 그 하위의 앞에 Test가 붙은 파일들
 추후 테스트가 문제 없을시 파일 및 폴더 전체제거 OR 분리작업 예정
 */

import UIKit
import FirebaseFirestore
import SnapKit

class TestPostVC: UIViewController {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private var currentPost: TestPost?
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.text = "태그"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.text = "제목"
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.text = "내용"
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "작성자"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "날짜"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TestPostVC - viewDidLoad 호출")
        print("navigationController 확인:", navigationController ?? "nil")
        setupUI()
        setupNavigationBar()
        fetchTestPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTestPost() // 화면이 나타날 때마다 데이터 새로고침
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(cardView)
        [tagsLabel, titleLabel, detailLabel, nickNameLabel, dateLabel].forEach {
            cardView.addSubview($0)
        }
        
        setupConstraints()
        
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(tagsLabel)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(detailLabel.snp.bottom).offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel)
            make.centerY.equalTo(nickNameLabel)
        }
    }
    
    private func setupNavigationBar() {
        title = "게시글 목록"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "글쓰기",
            style: .plain,
            target: self,
            action: #selector(writeButtonTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func writeButtonTapped() {
        let uploadVC = TestPostUploadVC()
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @objc private func cardViewTapped() {
        print("카드뷰가 탭되었습니다.")
        guard let post = currentPost else {
            print("현재 포스트가 없습니다.")
            return
        }
        print("포스트 데이터 전달 시작: \(post)")
        
        let detailVC = TestPostDetailVC()
        detailVC.post = post
        
        // navigationController 확인
        if let navigationController = self.navigationController {
            print("navigationController 존재, 화면 전환 시도")
            navigationController.pushViewController(detailVC, animated: true)
        } else {
            print("navigationController가 nil입니다")
        }
    }
    
    
    
    // MARK: - Data Fetching
    private func fetchTestPost() {
        TestPostService.shared.fetchLatestPost { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let post):
                self.currentPost = post
                DispatchQueue.main.async {
                    self.configureWithPost(post)
                }
            case .failure(let error):
                print("Error fetching post: \(error.localizedDescription)")
                // TODO: 에러 처리 (예: 알림 표시)
            }
        }
    }
    
    private func configureWithPost(_ post: TestPost) {
        // 모든 태그 정보를 한 줄로 표시
        let tags = [
            post.position,
            "모집인원: \(post.recruits)",
            post.experience
        ] + post.techstack
        
        tagsLabel.text = tags.joined(separator: " • ")
        titleLabel.text = post.title
        detailLabel.text = post.detail
        nickNameLabel.text = "작성자: \(post.nickName)"
        
        if let timestamp = post.createdDate {
            let date = timestamp.dateValue()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yy년 M월 d일 a h시 mm분"
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = "날짜 없음"
        }
    }
}



@available(iOS 17.0, *)
#Preview {
    TestPostVC()
}
