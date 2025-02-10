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
    let postId: String 
    let reportReason: String
    let reportDetails: String
    let title: String
    let reporterNickname: String
    let creationTime: String
    let nickname: String
    
    var toDictionary: [String: Any] {
        return [
            "postId": postId,
            "reportReason": reportReason,
            "reportDetails": reportDetails,
            "title": title,
            "reporterNickname": reporterNickname,
            "creationTime": creationTime,
            "nickname": nickname
        ]
    }
}
