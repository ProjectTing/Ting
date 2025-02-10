//
//  ReportManager.swift
//  Ting
//
//  Created by 유태호 on 2/4/25.
//

import FirebaseFirestore

class ReportManager {
    static let shared = ReportManager()
    private let db = Firestore.firestore()      // Firestore 데이터베이스 참조
    private let reportCollection = "reports"    // Firestore에서 사용할 신고 컬렉션 이름
    
    private init() {} // 싱글톤 패턴을 위한 private 생성자
    
    func uploadReport(_ report: Report, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(report)   // Report 객체를 Firestore 데이터 형식으로 인코딩
            // Firestore에 데이터 추가
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
    
    /// 현재 시간을 문자열로 반환하는 메서드
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"    // - Returns: "yyyy/MM/dd" 형식의 현재 날짜 문자열
        return formatter.string(from: Date())
    }
    
    /// 중복 신고 여부를 확인하는 메서드
    func checkDuplicateReport(postId: String, reporterNickname: String, completion: @escaping (Bool) -> Void) {
        db.collection(reportCollection)
            .whereField("postId", isEqualTo: postId)                    // 어떤 게시글인지 체크
        .whereField("reporterNickname", isEqualTo: reporterNickname)    // 신고자 닉네임 체크
        .getDocuments { snapshot, error in
            if let error = error {
                print("Error checking duplicate report: \(error)")
                completion(false)
                return
            }
            
            // 문서가 존재하면 이미 신고한 것
            let isDuplicate = !(snapshot?.documents.isEmpty ?? true)
            completion(isDuplicate)
        }
    }
}
