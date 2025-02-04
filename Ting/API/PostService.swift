//
//  PostService.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import FirebaseFirestore
import RxSwift

class PostService {
    
    static let shared = PostService()
    private let db = Firestore.firestore()
    private init() {}
    
    // 데이터 업로드
    func uploadPost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(post) // Firestore에 저장할 수 있는 형태로 인코딩
            db.collection("posts").addDocument(data: data) { error in
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
    
    /// TODO - 페이징 처리, 제한갯수 설정 필요
    // 데이터 조회
    func getPostList(type: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection("posts")
            .whereField("postType", isEqualTo: type)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.compactMap { document -> Post? in
                    try? document.data(as: Post.self)
                }
                completion(.success(posts))
            }
    }
}

