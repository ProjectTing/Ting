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
    
    func updateReportNicknames(oldNickname: String, newNickname: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // 작성자로 신고된 경우와 신고자인 경우 모두 처리
        let batch = db.batch()
        
        // 1. 신고 받은 사람의 닉네임 업데이트
        db.collection(reportCollection)
            .whereField("nickname", isEqualTo: oldNickname)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // 2. 신고자의 닉네임 업데이트
                self.db.collection(reportCollection)
                    .whereField("reporterNickname", isEqualTo: oldNickname)
                    .getDocuments { snapshot2, error2 in
                        if let error2 = error2 {
                            completion(.failure(error2))
                            return
                        }
                        
                        // 신고 받은 사람으로 등록된 문서 업데이트
                        snapshot?.documents.forEach { doc in
                            let docRef = self.db.collection(self.reportCollection).document(doc.documentID)
                            batch.updateData(["nickname": newNickname], forDocument: docRef)
                        }
                        
                        // 신고자로 등록된 문서 업데이트
                        snapshot2?.documents.forEach { doc in
                            let docRef = self.db.collection(self.reportCollection).document(doc.documentID)
                            batch.updateData(["reporterNickname": newNickname], forDocument: docRef)
                        }
                        
                        // 일괄 업데이트 실행
                        batch.commit { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }
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
