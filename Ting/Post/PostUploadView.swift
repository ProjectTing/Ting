//
//  PostUploadView.swift
//  Ting
//
//  Created by t2023-m0033 on 1/24/25.
//

import UIKit
import SnapKit
import Then

final class PostUploadView: UIView {
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    private let postTypeLabel = UILabel().then {
        $0.text = "팀원구함 글 작성"
        $0.textColor = .deepCocoa
        $0.font = .systemFont(ofSize: 22, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let positionLabel = UILabel().then {
        $0.text = "필요한 직무 (중복가능)"
        $0.textColor = .deepCocoa
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let positionButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let teckstackLabel = UILabel().then {
        $0.text = "필요한 기술 스택"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let teckstackTextField = UITextField().then {
        $0.placeholder = "필요한 기술 스택을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = UIColor.grayCloud.cgColor
    }
    
    private let urgencyLabel = UILabel().then {
        $0.text = "시급성"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    
    private let urgencyButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let ideaStatusLabel = UILabel().then {
        $0.text = "아이디어 상황"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let ideaStatusButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let recruitsLabel = UILabel().then {
        $0.text = "모집 인원"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    // TODO: - 모집 인원 피커뷰 ? or 다른 방법 생각해보기
    private let recruitsTextField = UITextField().then {
        $0.placeholder = "모집 인원을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.layer.borderColor = UIColor.grayCloud.cgColor
    }
    
    private let meetingStyleLabel = UILabel().then {
        $0.text = "선호하는 작업 방식"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let meetingStyleButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    // TODO: - 구직 게시판으로 넘겨도 될듯
    private let experienceLabel = UILabel().then {
        $0.text = "경험"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let experienceButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let detailLabel = UILabel().then {
        $0.text = "내용"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    private let detailTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 16)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayCloud.cgColor
        $0.layer.cornerRadius = 8
        $0.text = " [작성 예시] \n 프로젝트 주제: \n 목표: \n 예상 일정(횟수): \n 모집 이유: \n 지원방법(이메일, 오픈채팅, 구글폼 등): \n 참고 사항: "
    }
    
    // 작성하기 버튼
    private let submitButton = UIButton().then {
        $0.setTitle("게시글 작성", for: .normal)
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    // 태그 버튼 타이틀 배열
    private let positionTitleArray = ["개발", "디자이너", "기획자", "기타"]
    
    private let urgencyTitleArray = ["급함", "보통", "여유로움"]
    
    private let ideaStatusTitleArray = ["구체적임", "모호함", "없음"]
    
    private let meetingStyleTitleArray = ["온라인", "오프라인", "무관"]
    
    private let experienceTitleArray = ["입문", "취준", "현업", "경력", "기타"]
    
    // 스택뷰와 타이틀 배열을 쌍으로 만듦
    private lazy var stackViewsWithTitles: [(UIStackView, [String])] = [
        (positionButtonStack, positionTitleArray),
        (urgencyButtonStack, urgencyTitleArray),
        (ideaStatusButtonStack, ideaStatusTitleArray),
        (meetingStyleButtonStack, meetingStyleTitleArray),
        (experienceButtonStack, experienceTitleArray)
    ]
    
    // 선택된 버튼들을 추적하기 위한 프로퍼티
    private var selectedPositions: Set<String> = [] // 집합으로 중복선택 가능 구현
    private var selectedUrgency: String?
    private var selectedIdeaStatus: String?
    private var selectedMeetingStyle: String?
    private var selectedExperience: String?
    
    // MARK: - 생성자
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTagButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    
    private func setupUI() {
        self.backgroundColor = .background
        [
            scrollView,
            submitButton
        ].forEach {
            self.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [
            postTypeLabel,
            positionLabel,
            positionButtonStack,
            teckstackLabel,
            teckstackTextField,
            urgencyLabel,
            urgencyButtonStack,
            ideaStatusLabel,
            ideaStatusButtonStack,
            recruitsLabel,
            recruitsTextField,
            meetingStyleLabel,
            meetingStyleButtonStack,
            experienceLabel,
            experienceButtonStack,
            titleLabel,
            titleTextField,
            detailLabel,
            detailTextView
        ].forEach {
            contentView.addSubview($0)
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280) // 버튼 너비
            $0.height.equalTo(50) // 버튼 높이
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        postTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        positionLabel.snp.makeConstraints {
            $0.top.equalTo(postTypeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        positionButtonStack.snp.makeConstraints {
            $0.top.equalTo(positionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        teckstackLabel.snp.makeConstraints {
            $0.top.equalTo(positionButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        teckstackTextField.snp.makeConstraints {
            $0.top.equalTo(teckstackLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        urgencyLabel.snp.makeConstraints {
            $0.top.equalTo(teckstackTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        urgencyButtonStack.snp.makeConstraints {
            $0.top.equalTo(urgencyLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        ideaStatusLabel.snp.makeConstraints {
            $0.top.equalTo(urgencyButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        ideaStatusButtonStack.snp.makeConstraints {
            $0.top.equalTo(ideaStatusLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        recruitsLabel.snp.makeConstraints {
            $0.top.equalTo(ideaStatusButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        recruitsTextField.snp.makeConstraints {
            $0.top.equalTo(recruitsLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingStyleLabel.snp.makeConstraints {
            $0.top.equalTo(recruitsTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingStyleButtonStack.snp.makeConstraints {
            $0.top.equalTo(meetingStyleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        experienceLabel.snp.makeConstraints {
            $0.top.equalTo(meetingStyleButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        experienceButtonStack.snp.makeConstraints {
            $0.top.equalTo(experienceLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(experienceButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        detailTextView.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    // MARK: - 메서드
    
    // 타이틀 배열로 각 스택뷰에 버튼 생성
    private func setupTagButtons() {
        for (stackView, titles) in stackViewsWithTitles {
            for title in titles {
                let button = CustomTag(
                    title: title,
                    titleColor: .primary,
                    strokeColor: .primary,
                    backgroundColor: .white,
                    isButton: true
                )
                button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    // 태그 클릭 관련
    @objc private func tagButtonTapped(_ sender: CustomTag) {
        guard let stackView = sender.superview as? UIStackView,
              let title = sender.titleLabel?.text else { return }
        
        // 직무 스택뷰인 경우 (다중 선택 가능)
        if stackView == positionButtonStack {
            sender.isSelected.toggle()
            if sender.isSelected {
                selectedPositions.insert(title)
            } else {
                selectedPositions.remove(title)
            }
            return
        }
        
        // 나머지 스택뷰들 (단일 선택)
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? CustomTag, button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected.toggle()
    }
}
