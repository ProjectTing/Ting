//
//  TestPostDetailVC.swift
//  Ting
//
//  Created by 유태호 on 1/22/25.
//

import UIKit
import SnapKit

class TestPostDetailVC: UIViewController {
    
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프론트엔드 개발자 구직중" // 데이터받고 수정필요
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let statusTagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let activityTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 가능 상태"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let availableTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "가능한 시간"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let availableTimeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "풀펫 참여 가능 시간" // 데이터받고 수정필요
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let timeStateLabel: UILabel = {
        let label = UILabel()
        label.text = "가능한시간"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let timeStateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "풀펫 참여 가능 시간" // 데이터받고 수정필요
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let urgencyLabel: UILabel = {
        let label = UILabel()
        label.text = "시급성"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let urgencyValueLabel: UILabel = {
        let label = UILabel()
        label.text = "여유로움" // 데이터받고 수정필요
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let techStackLabel: UILabel = {
        let label = UILabel()
        label.text = "보유 기술 스택"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let techStacksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let projectTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 목적"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let projectTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 가치관"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "협업을 통해 함께 성장하고 싶습니다. 열정적인 팀원들과 함께 의미있는 프로젝트를 만들어가고 싶습니다. 실제 서비스 런칭 경험을 쌓고 싶으며, 체계적인 프로젝트 진행을 선호합니다." // 데이터받고 수정필요
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("신고하기", for: .normal)
        button.backgroundColor = UIColor(red: 0.76, green: 0.18, blue: 0.07, alpha: 1.0)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTags()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.93, alpha: 1.0)
        setupScrollView()
        setupConstraints()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to contentView
        [titleLabel, statusTagsStackView, activityTimeLabel,
         availableTimeLabel, availableTimeValueLabel,
         timeStateLabel, timeStateValueLabel,
         urgencyLabel, urgencyValueLabel,
         techStackLabel, techStacksStackView,
         projectTypeLabel, projectTypeStackView,
         descriptionLabel, descriptionTextView].forEach { contentView.addSubview($0) }
         
        view.addSubview(applyButton) // 버튼은 스크롤뷰 밖으로 이동
    }
    
    private func setupConstraints() {
        // ScrollView 제약조건 수정
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyButton.snp.top).offset(-16)
        }
        
        // ContentView 제약조건
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        // Apply 버튼 제약조건
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        statusTagsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        activityTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(statusTagsStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        availableTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(activityTimeLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        availableTimeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(availableTimeLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        timeStateLabel.snp.makeConstraints { make in
            make.top.equalTo(availableTimeLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
        }
        
        timeStateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeStateLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        urgencyLabel.snp.makeConstraints { make in
            make.top.equalTo(timeStateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
        }
        
        urgencyValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(urgencyLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        techStackLabel.snp.makeConstraints { make in
            make.top.equalTo(urgencyLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        techStacksStackView.snp.makeConstraints { make in
            make.top.equalTo(techStackLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        projectTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(techStacksStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        projectTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(projectTypeLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(projectTypeStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    private func setupTags() {
        // Status Tags
        let statusTags = ["온라인", "경력 2년", "실무 경험"] // 데이터받고 수정필요
        statusTags.forEach { tag in
            let tagView = createTagView(text: tag)
            statusTagsStackView.addArrangedSubview(tagView)
        }
        
        // Tech Stack Tags
        let techStacks = ["React", "Swift", "Node.js"] // 데이터받고 수정필요
        techStacks.forEach { tech in
            let tagView = createTagView(text: tech)
            techStacksStackView.addArrangedSubview(tagView)
        }
        
        // Project Type Tags
        let projectTypes = ["포트폴리오", "사이드 프로젝트"] // 데이터받고 수정필요
        projectTypes.forEach { type in
            let tagView = createTagView(text: type)
            projectTypeStackView.addArrangedSubview(tagView)
        }
    }
    
    private func createTagView(text: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0).cgColor
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 0.98, green: 0.57, blue: 0.24, alpha: 1.0)
        label.font = .systemFont(ofSize: 14)
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        return containerView
    }
}

@available(iOS 17.0, *)
#Preview {
    TestPostDetailVC()
}
