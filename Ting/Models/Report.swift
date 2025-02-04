//
//  Report.swift
//  Ting
//
//  Created by 유태호 on 2/4/25.
//

import FirebaseFirestore

/// 신고 모델 구조체
struct Report: Codable {
    @DocumentID var id: String?
    
    let reportReason: String      // 신고 사유
    let reportDetails: String     // 상세 내용
    let title: String            // 게시글 제목
    let reporterNickname: String  // 신고자 닉네임
    let creationTime: String      // 작성 시간
    let nickname: String          // 신고받는 사람 닉네임
    
    var toDictionary: [String: Any] {
        return [
            "reportReason": reportReason,
            "reportDetails": reportDetails,
            "title": title,
            "reporterNickname": reporterNickname,
            "creationTime": creationTime,
            "nickname": nickname
        ]
    }
}
