//
//  PostService.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import FirebaseFirestore
import RxSwift

class PostService {
    
    private let db = Firestore.firestore()
    
    // 데이터 업로드 -> Completable
    func uploadPost(post: Post) -> Completable  {
        return Completable.create { [weak self] completable in
            do {
                // Firestore에 저장할 수 있는 형태로 인코딩
                let data = try Firestore.Encoder().encode(post)
                self?.db.collection("posts").addDocument(data: data) { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    /// TODO - 페이징 처리, 제한갯수 설정 필요
    // 데이터 조회 -> Single
    func getPostList(type: String) -> Single<[Post]>  {
        return Single.create { [weak self] single in
            self?.db.collection("posts")
                .whereField("postType", isEqualTo: type)
                .order(by: "createdAt", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        single(.success([]))
                        return
                    }
                    
                    let posts = documents.compactMap { document -> Post? in
                        try? document.data(as: Post.self) }
                    single(.success(posts))
                }
                return Disposables.create()
        }
    }
}

