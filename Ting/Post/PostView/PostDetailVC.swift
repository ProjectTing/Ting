//
//  PostDetailVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

class PostDetailVC: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whiteCardView = UIView()
    private let titleLabel = UILabel()
    private let statusTagsView = TagFlowLayout()
    private let activityTimeLabel = UILabel()
    private let urgencyLabel = UILabel()
    private let urgencyValueLabel = UILabel()
    private let techStackLabel = UILabel()
    private let techStacksView = TagFlowLayout()
    private let projectTypeLabel = UILabel()
    private let projectTypeView = TagFlowLayout()
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let reportButton = UIButton()
    private let editButton = UIButton()
    
    private let postType: PostType
    private var post: Post?
    private let currentUserNickname: String
    weak var delegate: PostListUpdater?
    
    // MARK: - Initialization
    init(postType: PostType, post: Post, currentUserNickname: String) {
        self.postType = postType
        self.post = post
        self.currentUserNickname = currentUserNickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 게시글 데이터 새로고침
        if let postId = post?.id {
            refreshPostData(postId: postId)
        }
    }
    
    private func refreshPostData(postId: String) {
        PostService.shared.getPost(id: postId) { [weak self] result in
            switch result {
            case .success(let updatedPost):
                self?.post = updatedPost
                DispatchQueue.main.async {
                    self?.setupLabels()
                    self?.setupTags()
                }
            case .failure(let error):
                print("Error refreshing post data: \(error)")
            }
        }
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setupBasic()
        setupComponents()
        setupConstraints()
    }
    
    private func setupBasic() {
        view.backgroundColor = .background
        scrollView.backgroundColor = .clear
        
        whiteCardView.backgroundColor = .white
        whiteCardView.layer.cornerRadius = 12
        whiteCardView.layer.shadowColor = UIColor.black.cgColor
        whiteCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        whiteCardView.layer.shadowRadius = 4
        whiteCardView.layer.shadowOpacity = 0.1
        whiteCardView.clipsToBounds = false
    }
    
    private func setupComponents() {
        setupLabels()
        setupTags()
        setupButton()
        addSubviews()
    }
    
    private func setupLabels() {
        guard let post = post else { return }
        
        titleLabel.text = post.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .deepCocoa
        
        activityTimeLabel.text = "활동 가능 상태"
        activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        activityTimeLabel.textColor = .deepCocoa
        
        urgencyLabel.text = "시급성"
        urgencyLabel.font = .systemFont(ofSize: 16)
        urgencyLabel.textColor = .brownText
        
        urgencyValueLabel.text = post.urgency ?? "정보 없음"
        urgencyValueLabel.font = .systemFont(ofSize: 16)
        urgencyValueLabel.textColor = .deepCocoa
        urgencyValueLabel.textAlignment = .right
        
        techStackLabel.text = "보유 기술 스택"
        techStackLabel.font = .systemFont(ofSize: 18, weight: .medium)
        techStackLabel.textColor = .deepCocoa
        
        projectTypeLabel.text = "프로젝트 목적"
        projectTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        projectTypeLabel.textColor = .deepCocoa
        
        descriptionLabel.text = "프로젝트 설명"
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .deepCocoa
        
        descriptionTextView.text = post.detail
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.textColor = .deepCocoa
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            // 활동가능상태 위에 구분선 추가
            let statusSeparator = UIView()
            statusSeparator.backgroundColor = .grayCloud
            self.whiteCardView.addSubview(statusSeparator)
            
            statusSeparator.snp.makeConstraints { make in
                make.top.equalTo(self.activityTimeLabel.snp.top).offset(-8)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(1)
            }
            //구분선들
            [self.activityTimeLabel, self.techStackLabel, self.projectTypeLabel,].forEach { label in
                let separator = UIView()
                separator.backgroundColor = .grayCloud
                self.whiteCardView.addSubview(separator)
                
                separator.snp.makeConstraints { make in
                    if label == self.activityTimeLabel {
                        make.top.equalTo(self.urgencyLabel.snp.bottom).offset(16)
                    } else if label == self.techStackLabel {
                        make.top.equalTo(self.techStacksView.snp.bottom).offset(16)
                    } else if label == self.projectTypeLabel {
                        make.top.equalTo(self.projectTypeView.snp.bottom).offset(16)
                    }
                    make.left.right.equalToSuperview().inset(20)
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    private func setupTags() {
        guard let post = post else { return }
        
        // 기존 태그들 모두 제거
        statusTagsView.removeAllTags()
        techStacksView.removeAllTags()
        projectTypeView.removeAllTags()
        
        // Position 태그 설정
        post.position.forEach { tag in
            statusTagsView.addTag(createTagView(text: tag))
        }
        
        // Tech Stack 태그 설정
        post.techStack.forEach { tag in
            techStacksView.addTag(createTagView(text: tag))
        }
        
        // 프로젝트 타입 태그 설정
        [post.ideaStatus, post.meetingStyle].forEach { tag in
            projectTypeView.addTag(createTagView(text: tag))
        }
    }
    
    private func createTagView(text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.secondaries.cgColor
        
        let label = UILabel()
        label.text = text
        label.textColor = .secondaries
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        
        containerView.addSubview(label)
        
        let width = text.size(withAttributes: [.font: label.font!]).width + 32
        containerView.frame.size = CGSize(width: width, height: 30)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        return containerView
    }
    
    private func setupButton() {
        reportButton.setTitle("신고하기", for: .normal)
        reportButton.backgroundColor = .primaries
        reportButton.layer.cornerRadius = 10
        reportButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        reportButton.setTitleColor(.white, for: .normal)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        
        editButton.setTitle("편집하기", for: .normal)
        editButton.backgroundColor = .primaries
        editButton.layer.cornerRadius = 10
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        editButton.setTitleColor(.white, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        reportButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        editButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        if let postNickname = post?.nickName {
            print("Post Nickname:", postNickname)
            print("Current User Nickname:", currentUserNickname)
            if postNickname == currentUserNickname {
                editButton.isHidden = false
                reportButton.isHidden = true
            } else {
                editButton.isHidden = true
                reportButton.isHidden = false
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(whiteCardView)
        
        whiteCardView.addSubviews(
            titleLabel, statusTagsView, activityTimeLabel,
            urgencyLabel, urgencyValueLabel,
            techStackLabel, techStacksView,
            projectTypeLabel, projectTypeView,
            descriptionLabel, descriptionTextView,
            reportButton, editButton
        )
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        whiteCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        statusTagsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        activityTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(statusTagsView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        urgencyLabel.snp.makeConstraints { make in
            make.top.equalTo(activityTimeLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(20)
        }
        
        urgencyValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(urgencyLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        techStackLabel.snp.makeConstraints { make in
            make.top.equalTo(urgencyLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        techStacksView.snp.makeConstraints { make in
            make.top.equalTo(techStackLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        projectTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(techStacksView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        projectTypeView.snp.makeConstraints { make in
            make.top.equalTo(projectTypeLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(projectTypeView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(reportButton.snp.top).offset(-16)
        }
        
        reportButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        editButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func reportButtonTapped() {
    
        /// 회원인지 비회원인지 체크
        guard self.loginCheck() else { return }
        
        guard let post = post else { return }
        
        let reportVC = ReportVC(post: post, reporterNickname: currentUserNickname)
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @objc private func editButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            guard let self = self,
                  let post = self.post else { return }
            
            switch self.postType {
            case .recruitMember:
                let uploadVC = RecruitMemberUploadVC()
                uploadVC.isEditMode = true
                uploadVC.editPostId = post.id
                
                // 기존 데이터 설정
                uploadVC.selectedPositions = post.position
                uploadVC.selectedUrgency = post.urgency ?? ""
                uploadVC.selectedIdeaStatus = post.ideaStatus
                uploadVC.selectedRecruits = post.numberOfRecruits
                uploadVC.selectedMeetingStyle = post.meetingStyle
                uploadVC.selectedExperience = post.experience ?? ""
                
                // 뷰 데이터 설정
                uploadVC.uploadView.techStackTextField.textField.text = post.techStack.joined(separator: ", ")
                uploadVC.uploadView.titleSection.textField.text = post.title
                uploadVC.uploadView.detailTextView.text = post.detail
                
                // 태그 버튼들의 선택 상태 설정
                uploadVC.uploadView.positionSection.setSelectedTag(titles: post.position)
                uploadVC.uploadView.urgencySection.setSelectedTag(titles: [post.urgency ?? ""])
                uploadVC.uploadView.ideaStatusSection.setSelectedTag(titles: [post.ideaStatus])
                uploadVC.uploadView.recruitsSection.setSelectedTag(titles: [post.numberOfRecruits])
                uploadVC.uploadView.meetingStyleSection.setSelectedTag(titles: [post.meetingStyle])
                uploadVC.uploadView.experienceSection.setSelectedTag(titles: [post.experience ?? ""])
                uploadVC.uploadView.submitButton.setTitle("수정하기", for: .normal)
                
                self.navigationController?.pushViewController(uploadVC, animated: true)
                
            case .joinTeam:
                let uploadVC = JoinTeamUploadVC()
                uploadVC.isEditMode = true
                uploadVC.editPostId = post.id
                
                // 기존 데이터 설정
                uploadVC.selectedPositions = post.position
                uploadVC.selectedAvailable = post.available ?? ""
                uploadVC.selectedIdeaStatus = post.ideaStatus
                uploadVC.selectedTeamSize = post.numberOfRecruits
                uploadVC.selectedMeetingStyle = post.meetingStyle
                uploadVC.selectedCurrentStatus = post.currentStatus ?? ""
                
                // 뷰 데이터 설정
                uploadVC.uploadView.techStackTextField.textField.text = post.techStack.joined(separator: ", ")
                uploadVC.uploadView.titleSection.textField.text = post.title
                uploadVC.uploadView.detailTextView.text = post.detail
                
                // 태그 버튼들의 선택 상태 설정
                uploadVC.uploadView.positionSection.setSelectedTag(titles: post.position)
                uploadVC.uploadView.availableSection.setSelectedTag(titles: [post.available ?? ""])
                uploadVC.uploadView.ideaStatusSection.setSelectedTag(titles: [post.ideaStatus])
                uploadVC.uploadView.teamSizeSection.setSelectedTag(titles: [post.numberOfRecruits])
                uploadVC.uploadView.meetingStyleSection.setSelectedTag(titles: [post.meetingStyle])
                uploadVC.uploadView.currentStatusSection.setSelectedTag(titles: [post.currentStatus ?? ""])
                uploadVC.uploadView.submitButton.setTitle("수정하기", for: .normal)
                
                self.navigationController?.pushViewController(uploadVC, animated: true)
            }
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self = self,
                  let post = self.post,
                  let postId = post.id else { return }
            
            // 확인 알림창 추가
            let alert = UIAlertController(title: "삭제 확인",
                                          message: "정말 삭제하시겠습니까?",
                                          preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                PostService.shared.deletePost(id: postId) { result in
                    switch result {
                    case .success:
                        // 삭제 성공 시 이전 화면으로 돌아가기
                        DispatchQueue.main.async {
                            self?.delegate?.didUpdatePostList()
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        // 실패 시 에러 메시지 표시
                        DispatchQueue.main.async {
                            self?.basicAlert(title: "삭제 실패", message: "\(error.localizedDescription)")
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [editAction, deleteAction, cancelAction].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
}
