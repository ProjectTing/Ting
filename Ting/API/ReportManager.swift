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
}
