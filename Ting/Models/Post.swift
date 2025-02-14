//
//  Post.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import FirebaseFirestore

/// 게시글 모델 구조체
struct Post: Identifiable, Codable {
    // 공통 필드 (필수)
    @DocumentID var id: String? // Firestore 문서 ID (자동 생성)
    
    let userId: String   // 작성자의 uid
    let nickName: String  // 작성자 닉네임
    let postType: String // "팀원 모집" 또는 "팀 합류"
    let title: String   // 제목
    let detail: String  // 내용
    let position: [String] // 통일성을 위해 배열로 처리
    let techStack: [String] // 통일성을 위해 배열로 처리
    let ideaStatus: String  // 아이디어 상황
    let meetingStyle: String  // 선호하는 작업 방식
    let numberOfRecruits: String  // 모집 인원
    let createdAt: Date  // Firestore Timestamp와 자동 변환
    var reportCount: Int? = 0 // 신고 횟수
    
    // 팀원 모집 전용 필드 (옵셔널)
    var urgency: String? // 시급성 - "급함", "보통", "여유로움"
    var experience: String? // 경험 - "입문", "취준", "현업", "경력", "기타"
    
    // 팀 합류 전용 필드 (옵셔널)
    var available: String? // 참여가능 시기 - "즉시가능", "1주 이내", "협의가능", "기타"
    var currentStatus: String? // 현재상태 - "취준", "현업", "경력", "기타"
    
    /// 검색용 모든 태그들을 하나의 배열에 담기
    let tags: [String]
    let searchKeywords: [String]
}
