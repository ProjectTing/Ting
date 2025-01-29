//
//  FindTeamUploadView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class FindTeamUploadView: BaseUploadView {
    
    private lazy var positionSection = LabelAndTagStackView(
        title: "직무",
        tagTitles: ["개발", "디자이너", "기획자", "기타"]
    )
    
    private lazy var techStackSection = LabelAndTextFieldView(
        title: "보유 기술 스택",
        placeholder: " 보유한 기술 스택을 입력해주세요"
    )
    
    private lazy var availableSection = LabelAndTagStackView(
        title: "참여 가능 시기",
        tagTitles: ["즉시가능", "1주 이내", "협의가능", "기타"]
    )
    
    private lazy var ideaStatusSection = LabelAndTagStackView(
        title: "선호하는 프로젝트 단계",
        tagTitles: ["아이디어만", "기획 완료", "개발 진행중", "무관"]
    )
    
    private lazy var teamSizeSection = LabelAndTagStackView(
        title: "희망 팀 규모",
        tagTitles: ["~3명", "~5명", "무관", "기타"]
    )
    
    private lazy var meetingStyleSection = LabelAndTagStackView(
        title: "선호하는 작업 방식",
        tagTitles: ["온라인", "오프라인", "무관"]
    )
    
    private lazy var currentStatusSection = LabelAndTagStackView(
        title: "현재 상태",
        tagTitles: ["취준", "현업", "경력", "기타"]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        /// 게시글 타입 라벨
        postTypeLabel.text = "팀 구함 글 작성"
        
        /// 게시글 내용 양식 텍스트뷰
        detailTextView.text = " 자기소개: \n\n 원하는 프로젝트와 이유: \n\n 목표, 목적: \n\n 참여가능 일정(주 몇회, 시간대): \n\n 협업 스타일: \n\n 참고 사항 및 기타내용: \n\n 연락방법(이메일, 오픈채팅, 구글폼 등): \n"
        
        contentView.addSubviews(
            postTypeLabel,
            positionSection,
            techStackSection,
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
        
        techStackSection.snp.makeConstraints {
            $0.top.equalTo(positionSection.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        availableSection.snp.makeConstraints {
            $0.top.equalTo(techStackSection.snp.bottom).offset(20)
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
