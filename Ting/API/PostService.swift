//
//  PostService.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import FirebaseFirestore

class PostService {
    
    static let shared = PostService()
    private let db = Firestore.firestore()
    private init() {}
    
    // MARK: -  데이터 업로드
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
    
    // MARK: - 데이터 Read
    
    /// 최근글 3개
    func getLatestPost(type: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection("posts")
            .whereField("postType", isEqualTo: type)
            .order(by: "createdAt", descending: true)
            .limit(to: 3)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.compactMap { document -> Post? in
                    try? document.data(as: Post.self)
                }
                
                // 신고한 게시글 필터링
                UserInfoService.shared.filterReportedPosts(posts: posts) { filteredPosts in
                    self.getBlockedUsers { blockedUsers in
                        let finalPosts = filteredPosts.filter { post in
                            // 차단된 사용자의 게시글 제외
                            !blockedUsers.contains(post.userId)
                        }
                        completion(.success(finalPosts))
                    }
                }
                
            }
    }
    
    /// 게시글 리스트
    func getPostList(type: String?, position: String?, lastDocument: DocumentSnapshot?, completion: @escaping (Result<([Post], DocumentSnapshot?), Error>) -> Void) {
        var query: Query = db.collection("posts")
        
        if let type = type {
            query = query.whereField("postType", isEqualTo: type)
        }
        
        if let position = position {
            query = query.whereField("position", arrayContains: position)
        }
        
        query = query.order(by: "createdAt", descending: true).limit(to: 20)
        
        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success(([], nil)))
                return
            }
            
            let posts = documents.compactMap { try? $0.data(as: Post.self) }
            let lastDocument = documents.last
            
            // 신고한 게시글 필터링
            UserInfoService.shared.filterReportedPosts(posts: posts) { filteredPosts in
                self.getBlockedUsers { blockedUsers in
                    let finalPosts = filteredPosts.filter { post in
                        // 차단된 사용자의 게시글 제외
                        !blockedUsers.contains(post.userId)
                    }
                    completion(.success((finalPosts, lastDocument)))
                }
            }
        }
    }
    
    // MARK: - Update
    // Upload 객체
    func updatePost(id: String, post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection("posts").document(id).updateData(data) { error in
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
    
    // MARK: - Delete
    func deletePost(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("posts").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Search
    func searchPosts(searchText: String, selectedTags: [String], completion: @escaping (Result<[Post], Error>) -> Void) {
        
        var baseQuery: Query = db.collection("posts")
        
        // 1. Firestore에서 검색어 기반 필터링
        baseQuery = baseQuery.whereField("searchKeywords", arrayContains: searchText)
        
        baseQuery.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let filteredPosts: [Post] = documents.compactMap { try? $0.data(as: Post.self) }
            
            // 2. 신고된 게시글 및 차단된 사용자 필터링
            UserInfoService.shared.filterReportedPosts(posts: filteredPosts) { reportedFilteredPosts in
                self.getBlockedUsers { blockedUsers in
                    var finalPosts = reportedFilteredPosts.filter { post in
                        !blockedUsers.contains(post.userId)
                    }
                    
                    // 3. 앱 내에서 태그 기반 필터링
                    if !selectedTags.isEmpty {
                        finalPosts = finalPosts.filter { post in
                            // 선택된 태그가 게시글의 태그에 포함되어 있는지 확인
                            return selectedTags.contains(where: { post.tags.contains($0) })
                        }
                    }
                    
                    completion(.success(finalPosts))
                }
            }
        }
    }
    
    // MARK: - Helper
    /// 키워드를 저장하기 위한 메서드
    func generateSearchKeywords(from title: String) -> [String] {
        var keywords: Set<String> = []
        
        // 1. 공백과 특수문자 제거
        let cleanedTitle = title
            .replacingOccurrences(of: "[^가-힣a-zA-Z0-9 ]", with: "", options: .regularExpression) // 특수문자 제거
            .trimmingCharacters(in: .whitespacesAndNewlines) // 앞뒤 공백 제거
        
        let words = cleanedTitle.split(separator: " ").map { String($0) }
        
        // 2. 단어 자체를 키워드로 저장 + 2글자 이상일 경우 Prefix 생성
        for word in words {
            keywords.insert(word) // 원래 단어 저장
            
            if word.count > 1 { // 2글자 이상인 경우만 Prefix 생성
                for i in 2...word.count { // 2글자부터 Prefix 저장
                    let prefix = String(word.prefix(i))
                    keywords.insert(prefix)
                }
            }
        }
        
        return Array(keywords)
    }
    
    func getPost(id: String, completion: @escaping (Result<Post, Error>) -> Void) {
        db.collection("posts").document(id).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                return
            }
            
            do {
                let post = try document.data(as: Post.self)
                completion(.success(post))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// 차단한 사용자 목록 가져오기
    private func getBlockedUsers(completion: @escaping ([String]) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            completion([])
            return
        }
        
        let userRef = db.collection("infos").whereField("userId", isEqualTo: userId)
        userRef.getDocuments { userSnapshot, error in
            if let error = error {
                print("Error fetching user info: \(error)")
                completion([])
                return
            }
            
            guard let userDocument = userSnapshot?.documents.first,
                  let userInfo = try? userDocument.data(as: UserInfo.self) else {
                completion([])
                return
            }
            
            completion(userInfo.blockedUsers ?? [])
        }
    }
}

extension PostService {
    /// 게시글의 신고 카운트를 증가시키는 메서드
    func incrementReportCount(postId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection("posts").document(postId)
        
        // 트랜잭션을 사용하여 안전하게 카운트 증가
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            // 현재 reportCount 값 가져오기
            let currentCount = postDocument.data()?["reportCount"] as? Int ?? 0
            let newCount = currentCount + 1
            
            // reportCount 증가
            transaction.updateData(["reportCount": newCount], forDocument: postRef)
            
            // 신고 횟수가 5회 이상이면 삭제 표시
            if newCount >= 5 {
                return true // 삭제가 필요함을 표시
            }
            
            return false // 삭제가 필요하지 않음
            
        }) { (needsDelete, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 5회 이상 신고되었다면 게시글 삭제
            if needsDelete as? Bool == true {
                self.deletePost(id: postId) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.success(()))
            }
        }
    }
}
