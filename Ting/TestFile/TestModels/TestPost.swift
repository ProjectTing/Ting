//
//  TestPost.swift
//  Ting
//
//  Created by Watson on 1/22/25.
//

import Foundation
import FirebaseFirestore

struct TestPost: Codable {
    let createdDate:  Timestamp?
    let nickName: String
    let positionSearch: String    // "구인" 또는 "구직"
    let position: String          // 직무
    let availableTime: String     // 가능 시간
    let techstack: [String]       // 기술 스택 배열
    let urgencyLevel: String      // 시급성
    let specificity: String       // 아이디어상황
    let recruits: String          // 모집 인원
    let meeting: String           // 협업방식
    let experience: String        // 경험
    let title: String            // 제목
    let detail: String           // 상세 내용
    
    var asDictionary: [String: Any] {
        return [
            "createdDate": FieldValue.serverTimestamp(),
            "nickName": nickName,
            "positionSearch": positionSearch,
            "position": position,
            "availableTime": availableTime,
            "techstack": techstack,
            "urgencyLevel": urgencyLevel,
            "specificity": specificity,
            "recruits": recruits,
            "meeting": meeting,
            "experience": experience,
            "title": title,
            "detail": detail
        ]
    }
}
