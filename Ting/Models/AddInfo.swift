//
//  AddInfo.swift
//  Ting
//
//  Created by 이재건 on 2/4/25.
//

import FirebaseFirestore

/// 게시글 모델 구조체
struct AddInfo: Identifiable, Codable {
    // 공통 필드 (필수)
    @DocumentID var id: String? // Firestore 문서 ID (자동 생성)
    
    let nickName: String  // User 모델 생성 시 User 타입으로 변경 or userID로 변경
    let teckStack: String
    let tool: String
    let workStyle: String
    let location: String
    let interest: String
}
