//
//  PostDetailVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

class TagFlowLayout: UIView {
    private var tags: [UIView] = []
    private let horizontalSpacing: CGFloat = 8
    private let verticalSpacing: CGFloat = 8
    
    func addTag(_ tagView: UIView) {
        tags.append(tagView)
        addSubview(tagView)
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for tag in tags {
            let tagSize = tag.sizeThatFits(bounds.size)
            
            if currentX + tagSize.width > bounds.width {
                currentX = 0
                currentY += maxHeight + verticalSpacing
                maxHeight = 0
            }
            
            tag.frame = CGRect(x: currentX, y: currentY, width: tagSize.width, height: tagSize.height)
            currentX += tagSize.width + horizontalSpacing
            maxHeight = max(maxHeight, tagSize.height)
        }
        
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        var maxY: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for tag in tags {
            let tagSize = tag.sizeThatFits(bounds.size)
            
            if currentX + tagSize.width > bounds.width {
                currentX = 0
                currentY += maxHeight + verticalSpacing
                maxHeight = 0
            }
            
            currentX += tagSize.width + horizontalSpacing
            maxHeight = max(maxHeight, tagSize.height)
            maxY = currentY + maxHeight
        }
        
        return CGSize(width: bounds.width, height: maxY + verticalSpacing)
    }
}

class PostDetailVC: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whiteCardView = UIView()
    private let titleLabel = UILabel()
    private let statusTagsView = TagFlowLayout()
    private let activityTimeLabel = UILabel()
    private let availableTimeLabel = UILabel()
    private let availableTimeValueLabel = UILabel()
    private let timeStateLabel = UILabel()
    private let timeStateValueLabel = UILabel()
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
    private let post: Post?
    private let currentUserNickname: String
    
    // MARK: - Initialization
    init(postType: PostType) {
        self.postType = postType
        self.post = nil  // post 프로퍼티 초기화
        self.currentUserNickname = ""
        super.init(nibName: nil, bundle: nil)
    }

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
        // post가 옵셔널이므로 안전하게 언래핑
        guard let post = post else { return }
        
        // 실제 데이터로 변경
        titleLabel.text = post.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .deepCocoa
            
        activityTimeLabel.text = "활동 가능 상태"
        activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        activityTimeLabel.textColor = .deepCocoa
            
        availableTimeLabel.text = "가능한 기간"
        availableTimeLabel.font = .systemFont(ofSize: 16)
        availableTimeLabel.textColor = .brownText
            
        availableTimeValueLabel.text = post.available ?? "정보 없음"
        availableTimeValueLabel.font = .systemFont(ofSize: 16)
        availableTimeValueLabel.textColor = .deepCocoa
        availableTimeValueLabel.textAlignment = .right
            
        timeStateLabel.text = "가능한 시간"
        timeStateLabel.font = .systemFont(ofSize: 16)
        timeStateLabel.textColor = .brownText
            
        timeStateValueLabel.text = post.currentStatus ?? "정보 없음"
        timeStateValueLabel.font = .systemFont(ofSize: 16)
        timeStateValueLabel.textColor = .deepCocoa
        timeStateValueLabel.textAlignment = .right
            
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
           statusSeparator.backgroundColor = UIColor.systemGray5
           self.whiteCardView.addSubview(statusSeparator)
           
           statusSeparator.snp.makeConstraints { make in
               make.top.equalTo(self.activityTimeLabel.snp.top).offset(-8)
               make.left.right.equalToSuperview().inset(20)
               make.height.equalTo(1)
           }
           //구분선들
           [self.activityTimeLabel, self.techStackLabel, self.projectTypeLabel,].forEach { label in
               let separator = UIView()
               separator.backgroundColor = UIColor.systemGray5
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
        
        // Position 태그 설정 - position은 이미 [String] 타입이므로 옵셔널 체크 불필요
        post.position.forEach { tag in
            statusTagsView.addTag(createTagView(text: tag))
        }
        
        // Tech Stack 태그 설정 - techStack도 [String] 타입
        post.techStack.forEach { tag in
            techStacksView.addTag(createTagView(text: tag))
        }
        
        // 프로젝트 타입 태그는 상황에 맞게 설정
        // ideaStatus와 meetingStyle은 String 타입이므로 옵셔널 체크 불필요
        [post.ideaStatus, post.meetingStyle].forEach { tag in
            projectTypeView.addTag(createTagView(text: tag))
        }
    }
    
    private func createTagView(text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.secondary.cgColor
        
        let label = UILabel()
        label.text = text
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        
        containerView.addSubview(label)
        
        // 레이블에 고정 너비 설정
        let width = text.size(withAttributes: [.font: label.font!]).width + 32
        containerView.frame.size = CGSize(width: width, height: 30)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        return containerView
    }
    
    private func setupButton() {
        reportButton.setTitle("신고하기", for: .normal)
        reportButton.backgroundColor = .primary
        reportButton.layer.cornerRadius = 10  // 변경
        reportButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)  // 변경
        reportButton.setTitleColor(.white, for: .normal)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        
        editButton.setTitle("편집하기", for: .normal)
        editButton.backgroundColor = .primary
        editButton.layer.cornerRadius = 10  // 변경
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)  // 변경
        editButton.setTitleColor(.white, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        // 버튼 제약 조건도 수정 필요
        reportButton.snp.makeConstraints { make in
            make.height.equalTo(50)  // 변경
        }
        
        editButton.snp.makeConstraints { make in
            make.height.equalTo(50)  // 변경
        }

        // 닉네임 비교하여 버튼 표시 여부 결정
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
        
        whiteCardView.addSubviews([
            titleLabel, statusTagsView, activityTimeLabel,
            availableTimeLabel, availableTimeValueLabel,
            timeStateLabel, timeStateValueLabel,
            urgencyLabel, urgencyValueLabel,
            techStackLabel, techStacksView,
            projectTypeLabel, projectTypeView,
            descriptionLabel, descriptionTextView,
            reportButton, editButton
        ])
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
        
        availableTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(activityTimeLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
        }
        
        availableTimeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(availableTimeLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        timeStateLabel.snp.makeConstraints { make in
            make.top.equalTo(availableTimeLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(20)
        }
        
        timeStateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeStateLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        urgencyLabel.snp.makeConstraints { make in
            make.top.equalTo(timeStateLabel.snp.bottom).offset(12)
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
            make.top.equalTo(descriptionTextView.snp.bottom).offset(30)  // 간격 수정
            make.leading.trailing.equalToSuperview().inset(40)  // 간격 수정
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(30)  // 간격 수정
            make.leading.trailing.equalToSuperview().inset(40)  // 간격 수정
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func reportButtonTapped() {
        let post = Post(
            nickName: "작성자닉네임",
            postType: postType == .recruitMember ? "팀원구함" : "팀 구함",  // rawValue 대신 직접 문자열 지정
            title: titleLabel.text ?? "",
            detail: descriptionTextView.text,
            position: [],
            techStack: [],
            ideaStatus: "",
            meetingStyle: "",
            numberOfRecruits: "",
            createdAt: Date(),
            tags: [],
            searchKeywords: []
        )
        
        let reportVC = ReportVC(post: post, reporterNickname: "신고자닉네임")
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @objc private func editButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            guard let self = self,
                  let post = self.post else { return }  // post가 옵셔널이므로 언래핑
            
            // 게시글 타입에 따라 다른 VC 사용
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
/*
@available(iOS 17.0, *)
#Preview {
    // NavigationController로 감싸서 Preview 표시
    UINavigationController(rootViewController: PostDetailVC(postType: .recruitMember))
}
 */
/** todo list
 - firebase 연동후 작업해야 할 내용
 1. 들어오는 구인/구직 데이터에 따라서 디테일뷰 내 항목들 수정필요
    모집시 : 우대사항, 필요포지션, 프로젝트 상태, 필요 기술스택, 프로젝트 목적 및 목표
    구직시 : 보유역량, 활동가능상태, 기숤그택, 프로젝트목적, 프로젝트 가치관
 
 2. 신고하기,수정하기 기능 연동
    작성자와 조회하는 사람의 nickname이 다를 시 신고하기 버튼만 떠야함
    작성자와 조회하는 사람의 nickname이 같을 시 수정하시 버튼만 떠야함
 */
