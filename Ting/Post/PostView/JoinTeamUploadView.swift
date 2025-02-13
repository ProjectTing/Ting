//
//  JoinTeamUploadView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class JoinTeamUploadView: BaseUploadView {
    
    let postType: PostType = .joinTeam
    
    lazy var positionSection = LabelAndTagSection(postType: postType, sectionType: .position)
    
    lazy var techStackTextField = LabelAndTextField(
        title: "보유 기술 스택",
        placeholder: " 예시: Swift, Figma, 등등"
    )
    
    lazy var availableSection = LabelAndTagSection(postType: postType, sectionType: .available)
    
    lazy var ideaStatusSection = LabelAndTagSection(postType: postType, sectionType: .ideaStatus)
    
    lazy var teamSizeSection = LabelAndTagSection(postType: postType, sectionType: .numberOfRecruits)
    
    lazy var meetingStyleSection = LabelAndTagSection(postType: postType, sectionType: .meetingStyle)
    
    lazy var currentStatusSection = LabelAndTagSection(postType: postType, sectionType: .currentStatus)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupKeyboardNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 키보드 화면 위로 올리기 관련
    deinit {
        // 메모리 누수 방지
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        //  키보드가 텍스트뷰를 가리지 않도록 contentInset 조정
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = keyboardHeight + 20
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        //  원래 상태로 복구
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    private func setupUI() {
        /// 게시글 타입 라벨
        postTypeLabel.text = postType.postTitle
        
        /// 게시글 내용 양식 텍스트뷰
        detailTextView.text = postType.detailText
        
        contentView.addSubviews(
            postTypeLabel,
            positionSection,
            techStackTextField,
            availableSection,
            ideaStatusSection,
            teamSizeSection,
            meetingStyleSection,
            currentStatusSection,
            titleSection,
            detailLabel,
            detailTextView)
        
        postTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        positionSection.snp.makeConstraints {
            $0.top.equalTo(postTypeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        techStackTextField.snp.makeConstraints {
            $0.top.equalTo(positionSection.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        availableSection.snp.makeConstraints {
            $0.top.equalTo(techStackTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        ideaStatusSection.snp.makeConstraints {
            $0.top.equalTo(availableSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        teamSizeSection.snp.makeConstraints {
            $0.top.equalTo(ideaStatusSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingStyleSection.snp.makeConstraints {
            $0.top.equalTo(teamSizeSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        currentStatusSection.snp.makeConstraints {
            $0.top.equalTo(meetingStyleSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleSection.snp.makeConstraints {
            $0.top.equalTo(currentStatusSection.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        detailTextView.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(360)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
