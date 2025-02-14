//
//  PostDetailVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import FirebaseFirestore

class PostDetailVC: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whiteCardView = UIView()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let authInfoButton = UIButton()
    private let statusTagsView = TagFlowLayout()
    private let activityTimeLabel = UILabel()
    private let urgencyLabel = UILabel()
    private let urgencyValueLabel = UILabel()
    private let techStackLabel = UILabel()
    private let techStacksView = TagFlowLayout()
    private let ideaStatusLabel = UILabel()
    private let ideaStatusValueLabel = UILabel()
    private let recruitsLabel = UILabel()
    private let recruitsValueLabel = UILabel()
    private let meetingStyleLabel = UILabel()
    private let meetingStyleValueLabel = UILabel()
    private let experienceLabel = UILabel()
    private let experienceValueLabel = UILabel()
    private let positionLabel = UILabel()
    private let positionTagsView = TagFlowLayout()
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
    
    // MARK: - shadowPath Update (그림자 관련 경고문 삭제)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        whiteCardView.layer.shadowPath = UIBezierPath(
            roundedRect: whiteCardView.bounds,
            cornerRadius: whiteCardView.layer.cornerRadius).cgPath
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
        
        // Position 관련 UI visibility 및 높이 조절
        if postType == .recruitMember {
            positionLabel.isHidden = false
            positionTagsView.isHidden = false
            
            // 팀원 모집일 때는 정상적인 높이 설정
            positionLabel.snp.updateConstraints { make in
                make.height.equalTo(24) // 라벨 실제 높이
            }
            positionTagsView.snp.updateConstraints { make in
                make.height.equalTo(40) // 태그뷰 예상 높이
            }
            
            // 상단 여백도 정상 설정
            techStackLabel.snp.updateConstraints { make in
                make.top.equalTo(positionTagsView.snp.bottom).offset(24)
            }
            
            descriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(techStacksView.snp.bottom).offset(24)
                make.left.right.equalToSuperview().inset(20)
            }
        } else {
            positionLabel.isHidden = true
            positionTagsView.isHidden = true
            
            // 팀 합류일 때는 높이를 0으로 설정
            positionLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            positionTagsView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            // 상단 여백도 0으로 설정
            techStackLabel.snp.updateConstraints { make in
                make.top.equalTo(positionTagsView.snp.bottom).offset(0)
            }
            
            descriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(techStacksView.snp.bottom).offset(24)
                make.left.right.equalToSuperview().inset(20)
            }
        }
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
        setupButton()
        addSubviews()
    }
    
    private func setupLabels() {
        guard let post = post else { return }
        
        titleLabel.text = post.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .deepCocoa
        titleLabel.numberOfLines = 0                // 여러 줄 표시 설정
        titleLabel.lineBreakMode = .byWordWrapping  // 단어 단위로 줄바꿈
        
        nicknameLabel.text = "작성자: \(post.nickName)"
        nicknameLabel.font = .systemFont(ofSize: 14)
        nicknameLabel.textColor = .brownText
        
        activityTimeLabel.text = "요약정보"
        activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        activityTimeLabel.textColor = .deepCocoa
        
        if postType == .recruitMember {
            urgencyLabel.text = "시급성"
            urgencyValueLabel.text = post.urgency ?? "정보 없음"
        } else {
            urgencyLabel.text = "활동 가능 상태"
            urgencyValueLabel.text = post.available ?? "정보 없음"
        }
        urgencyLabel.font = .systemFont(ofSize: 16)
        urgencyLabel.textColor = .brownText
        
        urgencyValueLabel.font = .systemFont(ofSize: 16)
        urgencyValueLabel.textColor = .deepCocoa
        urgencyValueLabel.textAlignment = .right
        
        techStackLabel.text = postType == .recruitMember ? "필요 기술 스택" : "보유 기술 스택"
        techStackLabel.font = .systemFont(ofSize: 18, weight: .medium)
        techStackLabel.textColor = .deepCocoa
        
        ideaStatusLabel.text = "아이디어 상황"
        ideaStatusLabel.font = .systemFont(ofSize: 16)
        ideaStatusLabel.textColor = .brownText
        
        recruitsLabel.text = "모집인원"
        recruitsLabel.font = .systemFont(ofSize: 16)
        recruitsLabel.textColor = .brownText
        
        meetingStyleLabel.text = "선호하는 작업방식"
        meetingStyleLabel.font = .systemFont(ofSize: 16)
        meetingStyleLabel.textColor = .brownText
        
        experienceLabel.text = postType == .recruitMember ? "경험" : "현재 상태"
        experienceLabel.font = .systemFont(ofSize: 16)
        experienceLabel.textColor = .brownText
        
        positionLabel.text = "필요한 직무"
        positionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        positionLabel.textColor = .deepCocoa
        
        // 기존 레이블들과 동일한 스타일로 설정
        [ideaStatusValueLabel, recruitsValueLabel, meetingStyleValueLabel, experienceValueLabel].forEach { label in
            label.font = .systemFont(ofSize: 16)
            label.textColor = .deepCocoa
            label.textAlignment = .right
        }
        
        // 값 설정
        ideaStatusValueLabel.text = post.ideaStatus
        recruitsValueLabel.text = post.numberOfRecruits
        meetingStyleValueLabel.text = post.meetingStyle
        experienceValueLabel.text = postType == .recruitMember ? (post.experience ?? "정보 없음") : (post.currentStatus ?? "정보 없음")
        
        descriptionLabel.text = "프로젝트 설명"
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .deepCocoa
        
        descriptionTextView.text = post.detail
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.textColor = .deepCocoa
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
        
        // 구별선
        DispatchQueue.main.async {
            let activitySeparator = UIView()
            activitySeparator.backgroundColor = .grayCloud
            self.whiteCardView.addSubview(activitySeparator)
            
            activitySeparator.snp.makeConstraints { make in
                make.top.equalTo(self.activityTimeLabel.snp.top).offset(-8)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(1)
            }
            
            // postType에 따라 다른 배열을 사용
            let separatorLabels = self.postType == .recruitMember ?
            [self.positionLabel, self.techStackLabel, self.experienceLabel] :
            [self.techStackLabel, self.experienceLabel]
            
            separatorLabels.forEach { label in
                let separator = UIView()
                separator.backgroundColor = .grayCloud
                self.whiteCardView.addSubview(separator)
                
                separator.snp.makeConstraints { make in
                    if label == self.positionLabel {
                        make.top.equalTo(self.positionTagsView.snp.bottom).offset(16)
                    } else if label == self.techStackLabel {
                        make.top.equalTo(self.techStacksView.snp.bottom).offset(16)
                    } else if label == self.experienceLabel {
                        make.top.equalTo(self.experienceValueLabel.snp.bottom).offset(16)
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
        
        // 게시글 작성자의 role 정보 가져오기
        let db = Firestore.firestore()
        db.collection("infos")
            .whereField("nickName", isEqualTo: post.nickName)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let document = snapshot?.documents.first,
                   let userInfo = try? document.data(as: UserInfo.self) {
                    DispatchQueue.main.async {
                        self.statusTagsView.addTag(self.createTagView(text: userInfo.role))
                    }
                }
            }
        
        // Tech Stack 태그 설정
        post.techStack.forEach { tag in
            techStacksView.addTag(createTagView(text: tag))
        }
        
        // Position 태그 설정 (팀원 모집인 경우에만)
        if postType == .recruitMember {
            post.position.forEach { tag in
                positionTagsView.addTag(createTagView(text: tag))
            }
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
        authInfoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        authInfoButton.tintColor = .grayText
        authInfoButton.imageView?.contentMode = .scaleAspectFit
        authInfoButton.addTarget(self, action: #selector(authInfoButtonTapped), for: .touchUpInside)
        
        reportButton.setTitle("신고하기", for: .normal)
            reportButton.backgroundColor = .background
            reportButton.layer.cornerRadius = 10
            reportButton.layer.borderColor = UIColor.accent.cgColor // 테두리 색상 추가
            reportButton.layer.borderWidth = 1.5 // 테두리 두께 추가
            reportButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            reportButton.setTitleColor(.accent, for: .normal) // 텍스트 색상을 accent로 변경
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
                authInfoButton.isHidden = true
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
            titleLabel, nicknameLabel, authInfoButton, statusTagsView, activityTimeLabel,
            urgencyLabel, urgencyValueLabel,
            techStackLabel, techStacksView,
            ideaStatusLabel, ideaStatusValueLabel,
            recruitsLabel, recruitsValueLabel,
            meetingStyleLabel, meetingStyleValueLabel,
            experienceLabel, experienceValueLabel,
            positionLabel, positionTagsView,
            descriptionLabel, descriptionTextView
        )
        
        contentView.addSubview(reportButton)
        contentView.addSubview(editButton)
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
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(20)
        }
        
        authInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.left.equalTo(nicknameLabel.snp.right).offset(4)
            make.height.width.equalTo(16)
        }
        
        statusTagsView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
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
        
        ideaStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(urgencyLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        
        ideaStatusValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ideaStatusLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        recruitsLabel.snp.makeConstraints { make in
            make.top.equalTo(ideaStatusLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        
        recruitsValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitsLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        meetingStyleLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitsLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        
        meetingStyleValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(meetingStyleLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        experienceLabel.snp.makeConstraints { make in
            make.top.equalTo(meetingStyleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        
        experienceValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(experienceLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(24) // 초기 높이 설정
        }
        
        positionTagsView.snp.makeConstraints { make in
            make.top.equalTo(positionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40) // 초기 높이 설정
        }
        
        techStackLabel.snp.makeConstraints { make in
            make.top.equalTo(positionTagsView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        techStacksView.snp.makeConstraints { make in
            make.top.equalTo(techStackLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(techStacksView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)  // whiteCardView의 하단과의 간격
        }
       
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(whiteCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(whiteCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func authInfoButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let profileInfo = UIAlertAction(title: "프로필보기", style: .default) { [weak self] _ in
            self?.basicAlert(title: "업데이트 예정", message: "조금만 기다려주세요😊")
        }
        
        let blockUser = UIAlertAction(title: "차단하기", style: .destructive) { [weak self] _ in
            
            let confirmAlert = UIAlertController(title: "🚨 작성자 차단", message: "해당 사용자의 모든 게시글이 보이지 않습니다.", preferredStyle: .alert)
                // 확인 액션
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                
                guard let post = self?.post else { return }
                    
                // 차단할 사용자의 닉네임
                UserInfoService.shared.blockUser(nickName: post.nickName) { result in
                    switch result {
                    case .success:
                        self?.delegate?.didUpdatePostList()
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print("\(error)")
                        self?.basicAlert(title: "차단 실패", message: "")
                    }
                }
            }
            
            // 취소 액션
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
                    
            confirmAlert.addAction(confirmAction)
            confirmAlert.addAction(cancelAction)
            self?.present(confirmAlert, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(profileInfo)
        alert.addAction(blockUser)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc private func reportButtonTapped() {
    
        /// 회원인지 비회원인지 체크
        guard self.loginCheck() else { return }
        
        guard let post = post else { return }
        
        let reportVC = ReportVC(post: post, reporterNickname: currentUserNickname)
        reportVC.delegate = self
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

extension PostDetailVC: PostListUpdater {
       func didUpdatePostList() {
           // PostListVC에 업데이트 요청
           self.delegate?.didUpdatePostList()
       }
   }
