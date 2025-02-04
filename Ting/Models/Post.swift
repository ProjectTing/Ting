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
    
    let nickName: String  // User 모델 생성 시 User 타입으로 변경 or userID로 변경
    let postType: String // "팀원구함" 또는 "팀 구함"
    let title: String   // 제목
    let detail: String  // 내용
    let position: [String] // 통일성을 위해 배열로 처리
    let techStack: [String] // 통일성을 위해 배열로 처리
    let ideaStatus: String  // 아이디어 상황
    let meetingStyle: String  // 선호하는 작업 방식
    let numberOfRecruits: String  // 모집 인원
    let createdAt: Date  // Firestore Timestamp와 자동 변환
    
    // 팀원구함 전용 필드 (옵셔널)
    var urgency: String? // 시급성 - "급함", "보통", "여유로움"
    var experience: String? // 경험 - "입문", "취준", "현업", "경력", "기타"
    
    // 팀 구함 전용 필드 (옵셔널)
    var available: String? // 참여가능 시기 - "즉시가능", "1주 이내", "협의가능", "기타"
    var currentStatus: String? // 현재상태 - "취준", "현업", "경력", "기타"
}

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


class ReportManager {
    static let shared = ReportManager()
    private let db = Firestore.firestore()
    private let reportCollection = "reports"
    
    private init() {}
    
    func uploadReport(_ report: Report, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(report)
            db.collection(reportCollection).addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: Date())
    }
}
