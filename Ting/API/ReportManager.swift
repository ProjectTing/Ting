//
//  ReportManager.swift
//  Ting
//
//  Created by 유태호 on 2/4/25.
//

import FirebaseFirestore

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
    
    // 중복 신고 체크
    func checkDuplicateReport(postId: String, reporterNickname: String, completion: @escaping (Bool) -> Void) {
        db.collection(reportCollection)
        .whereField("postId", isEqualTo: postId)
        .whereField("reporterNickname", isEqualTo: reporterNickname)
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
