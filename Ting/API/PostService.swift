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
            /// Post 모델 구조체를 Firestore에 저장할 수 있는 형태로 인코딩
            let data = try Firestore.Encoder().encode(post)
            
            /// FireStore의 컬렉션 안에 "posts" 라는 이름으로 저장 (컬렉션 = 폴더 개념)
            /// addDocument : 컬렉션(폴더) 안에 문서를 저장하겠다. 위의 데이터를 가지고
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
    
    /// TODO - 페이징 처리, 제한갯수 보통 20개 정도 설정 필요
    /// 데이터 조회
    func getPostList(type: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection("posts")
            /// 조건설정 : posts의 postType이 파라미터의 type과 같은것을
            .whereField("postType", isEqualTo: type)
            /// 오더 - createdAt 을 내림차순으로 정렬해서
            .order(by: "createdAt", descending: true)
            /// get - 문서를 가져와라
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

