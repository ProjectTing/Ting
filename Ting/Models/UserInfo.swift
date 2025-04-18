//
//  UserInfo.swift
//  Ting
//
//  Created by 이재건 on 2/4/25.
//

import FirebaseFirestore

// 회원정보 추가 구조체
struct UserInfo: Identifiable, Codable {
    // 공통 필드 (필수)
    @DocumentID var id: String? // Firestore 문서 ID (자동 생성)
    
    let userId: String? // Firebase user.uid 저장
    let nickName: String
    let role: String
    let techStack: String
    let tool: String
    let workStyle: String
    let interest: String
    var reportedPosts: [String]? // 신고한 게시글 ID 목록
    var blockedUsers: [String]? // 차단한 사용자 uid 목록
}

