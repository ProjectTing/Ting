//
//  PostEnum.swift
//  Ting
//
//  Created by Watson22_YJ on 2/4/25.
//

import Foundation

/// 메인에서 앱,웹,디자이너,기획자 눌렀을때는 어떻게 할지 고민
// 게시판 타입에 따라 분기처리
enum PostType : String {
    case recruitMember = "팀원 모집"
    case joinTeam = "팀 합류"
    
    var postTitle: String {
        switch self {
        case .recruitMember:
            return "팀원 모집 글 작성"
        case .joinTeam:
            return "팀 합류 글 작성"
        }
    }
    
    var detailText : String {
        switch self {
        case .recruitMember:
            return "자기소개: \n\n프로젝트 주제: \n\n목표, 목적: \n\n예상 일정(주 몇회, 시간대): \n\n협업 스타일: \n\n원하는 팀원: \n\n참고 사항 및 기타내용: \n\n지원방법(이메일, 오픈채팅, 구글폼 등): \n"
        case .joinTeam:
            return "자기소개: \n\n원하는 프로젝트와 이유: \n\n목표, 목적: \n\n참여가능 일정(주 몇회, 시간대): \n\n협업 스타일: \n\n참고 사항 및 기타내용: \n\n연락방법(이메일, 오픈채팅, 구글폼 등): \n"
        }
    }
}

// 섹션 타입을 정의하는 enum
enum SectionType {
    case position
    case ideaStatus
    case meetingStyle
    case numberOfRecruits
    case urgency
    case experience
    case available
    case currentStatus
    
    // 섹션 title
    func title(postType: PostType) -> String {
        switch self {
        case .position:
            return postType == .recruitMember 
            ? "필요한 직무 (중복가능)" : "직무"
        case .ideaStatus:
            return postType == .recruitMember 
            ? "아이디어 상황" : "선호하는 프로젝트 단계"
        case .meetingStyle:
            return "선호하는 작업 방식"
        case .numberOfRecruits:
            return postType == .recruitMember 
            ? "모집 인원" : "희망 팀 규모"
        case .urgency:
            return "시급성"
        case .experience:
            return "경험"
        case .available:
            return "참여 가능 시기"
        case .currentStatus:
            return "현재 상태"
        }
    }
    
    // 섹션 태그버튼 title
    func tagTitles(postType: PostType) -> [String] {
        switch self {
        case .position:
            return ["개발자", "디자이너", "기획자", "기타"]
        case .ideaStatus:
            return postType == .recruitMember
            ? ["구체적임", "모호함", "없음"] : ["아이디어만", "기획 완료", "개발 진행중", "무관"]
        case .meetingStyle:
            return ["온라인", "오프라인", "무관"]
        case .urgency:
            return ["급함", "보통", "여유로움"]
        case .numberOfRecruits:
            return postType == .recruitMember
            ? ["~3명", "~5명", "무관", "기타"] : ["~3명", "~5명", "무관", "기타"]
        case .experience:
            return ["입문", "취준", "현업", "경력", "기타"]
        case .available:
            return ["즉시가능", "1주 이내", "협의가능", "기타"]
        case .currentStatus:
            return ["취준", "현업", "경력", "기타"]
        }
    }
}
