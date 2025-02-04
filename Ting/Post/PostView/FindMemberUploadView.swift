//
//  FindMemberUploadView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class FindMemberUploadView: BaseUploadView {
    
    lazy var positionSection = LabelAndTagStackView(
        title: "필요한 직무 (중복가능)",
        tagTitles: ["개발", "디자이너", "기획자", "기타"],
        isDuplicable: true
    )
    
    lazy var techStackTextField = LabelAndTextFieldView(
        title: "필요한 기술 스택",
        placeholder: " 예시: Swift, Figma, 등등"
    )
    
    lazy var urgencySection = LabelAndTagStackView(
        title: "시급성",
        tagTitles: ["급함", "보통", "여유로움"]
    )
    
    lazy var ideaStatusSection = LabelAndTagStackView(
        title: "아이디어 상황",
        tagTitles: ["구체적임", "모호함", "없음"]
    )
    
    lazy var recruitsSection = LabelAndTagStackView(
        title: "모집 인원",
        tagTitles: ["~3명", "~5명", "무관", "기타"]
    )
    
    lazy var meetingStyleSection = LabelAndTagStackView(
        title: "선호하는 작업 방식",
        tagTitles: ["온라인", "오프라인", "무관"]
    )
    
    lazy var experienceSection = LabelAndTagStackView(
        title: "경험",
        tagTitles: ["입문", "취준", "현업", "경력", "기타"]
    )    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    private func setupUI() {
        /// 게시글 타입 라벨
        postTypeLabel.text = "팀원구함 글 작성"
        
        /// 게시글 내용 텍스트뷰
        detailTextView.text = " 자기소개: \n\n 프로젝트 주제: \n\n 목표, 목적: \n\n 예상 일정(주 몇회, 시간대): \n\n 협업 스타일: \n\n 원하는 팀원: \n\n 참고 사항 및 기타내용: \n\n 지원방법(이메일, 오픈채팅, 구글폼 등): \n"
        
        contentView.addSubviews(
            postTypeLabel,
            positionSection,
            techStackTextField,
            urgencySection,
            ideaStatusSection,
            recruitsSection,
            meetingStyleSection,
            experienceSection,
            titleSection,
            detailLabel,
            detailTextView
        )
        
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
        
        urgencySection.snp.makeConstraints {
            $0.top.equalTo(techStackTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        ideaStatusSection.snp.makeConstraints {
            $0.top.equalTo(urgencySection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        recruitsSection.snp.makeConstraints {
            $0.top.equalTo(ideaStatusSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingStyleSection.snp.makeConstraints {
            $0.top.equalTo(recruitsSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        experienceSection.snp.makeConstraints {
            $0.top.equalTo(meetingStyleSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleSection.snp.makeConstraints {
            $0.top.equalTo(experienceSection.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        detailTextView.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
