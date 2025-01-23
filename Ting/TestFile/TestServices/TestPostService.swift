//
//  TestPostService.swift
//  Ting
//
//  Created by Watson on 1/22/25.
//

import Foundation
import FirebaseFirestore

class TestPostService {
    static let shared = TestPostService()
    private let db = Firestore.firestore()
    private init() {}
    
    func uploadPost(_ post: TestPost, completion: @escaping (Error?) -> Void) {
        db.collection("posts").addDocument(data: post.asDictionary) { error in
            completion(error)
        }
    }
    
    // 단일 게시글 가져오기 메서드 추가
    func fetchLatestPost(completion: @escaping (Result<TestPost, Error>) -> Void) {
        db.collection("posts")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                    return
                }
                
                let data = document.data()
                let post = TestPost(
                    createdDate: data["createdDate"] as? Timestamp,
                    nickName: data["nickName"] as? String ?? "",
                    positionSearch: data["positionSearch"] as? String ?? "",
                    position: data["position"] as? String ?? "",
                    availableTime: data["availableTime"] as? String ?? "",
                    techstack: data["techstack"] as? [String] ?? [],
                    urgencyLevel: data["urgencyLevel"] as? String ?? "",
                    specificity: data["specificity"] as? String ?? "",
                    recruits: data["recruits"] as? String ?? "",
                    meeting: data["meeting"] as? String ?? "",
                    experience: data["experience"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    detail: data["detail"] as? String ?? ""
                )
                
                completion(.success(post))
            }
    }
} 
