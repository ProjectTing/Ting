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
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
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
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxY: CGFloat = 0
        for tag in tags {
            maxY = max(maxY, tag.frame.maxY)
        }
        return CGSize(width: size.width, height: maxY + verticalSpacing)
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
        titleLabel.text = "프론트엔드 개발자 구직중"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .deepCocoa
        
        activityTimeLabel.text = "활동 가능 상태"
        activityTimeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        activityTimeLabel.textColor = .deepCocoa
        
        availableTimeLabel.text = "가능한 기간"
        availableTimeLabel.font = .systemFont(ofSize: 16)
        availableTimeLabel.textColor = .brownText
        
        availableTimeValueLabel.text = "풀펫 참여 가능 시간"
        availableTimeValueLabel.font = .systemFont(ofSize: 16)
        availableTimeValueLabel.textColor = .deepCocoa
        availableTimeValueLabel.textAlignment = .right
        
        timeStateLabel.text = "가능한 시간"
        timeStateLabel.font = .systemFont(ofSize: 16)
        timeStateLabel.textColor = .brownText
        
        timeStateValueLabel.text = "풀펫 참여 가능 시간"
        timeStateValueLabel.font = .systemFont(ofSize: 16)
        timeStateValueLabel.textColor = .deepCocoa
        timeStateValueLabel.textAlignment = .right
        
        urgencyLabel.text = "시급성"
        urgencyLabel.font = .systemFont(ofSize: 16)
        urgencyLabel.textColor = .brownText
        
        urgencyValueLabel.text = "여유로움"
        urgencyValueLabel.font = .systemFont(ofSize: 16)
        urgencyValueLabel.textColor = .deepCocoa
        urgencyValueLabel.textAlignment = .right
        
        techStackLabel.text = "보유 기술 스택"
        techStackLabel.font = .systemFont(ofSize: 18, weight: .medium)
        techStackLabel.textColor = .deepCocoa
        
        projectTypeLabel.text = "프로젝트 목적"
        projectTypeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        projectTypeLabel.textColor = .deepCocoa
        
        descriptionLabel.text = "프로젝트 가치관"
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .deepCocoa
        
        descriptionTextView.text = "협업을 통해 함께 성장하고 싶습니다. \n\n열정적인 팀원들과 함께 의미있는 프로젝트를 만들어가고 싶습니다. \n\n실제 서비스  런칭 경험을 쌓고 싶으며, 체계적인 프로젝트 진행을 선호합니다." // 추후 데이터값을 받고 내부값 수정 필요
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.textColor = .deepCocoa
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
    }
    
    private func setupTags() {
        ["온라인", "경력 2년", "실무 경험", "기죅자 구완", "디자이너 구와"].forEach { tag in
            statusTagsView.addTag(createTagView(text: tag))
        }
        
        ["React", "Swift", "Node.js", "Flutter", "ReactNative"].forEach { tag in
            techStacksView.addTag(createTagView(text: tag))
        }
        
        ["포트폴리오", "사이드 프로젝트"].forEach { tag in
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
       reportButton.layer.cornerRadius = 20
       reportButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
       reportButton.titleLabel?.font = .systemFont(ofSize: 16)
       
       editButton.setTitle("편집하기", for: .normal)
       editButton.backgroundColor = .accent
       editButton.layer.cornerRadius = 20
       editButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
       editButton.titleLabel?.font = .systemFont(ofSize: 16)
       editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
            make.height.equalTo(80)
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
            make.height.equalTo(50)
        }
        
        projectTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(techStacksView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        projectTypeView.snp.makeConstraints { make in
            make.top.equalTo(projectTypeLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
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
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.right.equalTo(view.snp.centerX).offset(-8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.left.equalTo(view.snp.centerX).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    @objc private func editButtonTapped() {
       let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
       let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
           // 수정 로직 구현
       }
       
       let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
           // 삭제 로직 구현
       }
       
       let cancelAction = UIAlertAction(title: "취소", style: .cancel)
       
       [editAction, deleteAction, cancelAction].forEach { alert.addAction($0) }
       
       present(alert, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    PostDetailVC()
}

/** todo list
 - firebase 연동후 작업해야 할 내용
 1. 들어오는 구인/구직 데이터에 따라서 디테일뷰 내 항목들 수정필요
    모집시 : 우대사항, 필요포지션, 프로젝트 상태, 필요 기술스택, 프로젝트 목적 및 목표
    구직시 : 보유역량, 활동가능상태, 기숤그택, 프로젝트목적, 프로젝트 가치관
 
 2. 신고하기,수정하기 기능 연동
    작성자와 조회하는 사람의 nickname이 다를 시 신고하기 버튼만 떠야함
    작성자와 조회하는 사람의 nickname이 같을 시 수정하시 버튼만 떠야함
 
 3. 수정하기 버튼 터치시 PostUploadVC에 출력되는 값들 고대로 해서 넘기면서 해당뷰로 넘어가게 기능구현 필요
 
 - 화면내 기능
 1. 신고하기, 수정하기 버튼 디자인 및 위치 조정 필요
    현재는 임시로 신고,수정을 각각 다른 색상의 임의 하단배치를 적용했지만 위의 2번 적용시 추후 위치 및 색상 조정 필요
    기존 피그마 초기안대로 구현하는것으로
    수정/삭제는 alert을 통해서 삭제할건지 수정할건지 정하고 - 완
 
 2. 네비게이션바를 사용한 좌측상단 뒤로가기 버튼 활성화
    네비게이션바를 사용해서 디테일뷰에서 내용 확인 후 뒤로가기 버튼 터치 시 postMainVC로 다시 넘어가게 기능구현 필요
 
 3. 태그들의 크기 관련
    게시글에 들어가는 태그 내용들을 고정크기로할지, 길이에 따라서 가변적으로 할지 설정작업 필요
 
 4. 글자 조정
    맨 하단의 텍스트라벨에서의 줄띄움 관련해서 로직 추가가 필요
 
 5. 신고하기 버튼 터치시 자동으로 ReportVC로 넘어가게 기능구현 필요
 6. 태그 세로로 쌓이게 하기 위해서 뷰 자체에 전체 스크롤링 뷰 적용 필요
 */
