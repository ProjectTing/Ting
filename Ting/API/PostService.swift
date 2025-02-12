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
                completion(.success(posts))
            }
    }
    
    /// 게시글 리스트
    func getPostList(type: String?, position: String?, lastDocument: DocumentSnapshot?, completion: @escaping (Result<([Post], DocumentSnapshot?), Error>) -> Void) {
        
        var query: Query = db.collection("posts")
        
        /// postType 이 있을 때 조건 적용 ( 리스트 )
        if let type = type {
            query = query.whereField("postType", isEqualTo: type)
        }
        
        /// position 있을 때 조건 적용 ( 메인에서 버튼탭 )
        if let position = position {
            query = query.whereField("position", arrayContains: position)
        }
        
        query = query
            .order(by: "createdAt", descending: true)
        // 최초 20개만
            .limit(to: 20)
        
        // 마지막 문서가 있으면 다음 페이지 쿼리
        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        /// get - 문서를 가져와라
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
            // 새로운 마지막 문서 저장
            let lastDocument = documents.last
            completion(.success((posts, lastDocument)))
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
    func searchPosts(searchText: String?, selectedTags: [String], completion: @escaping (Result<[Post], Error>) -> Void) {
    
        var baseQuery: Query = db.collection("posts")
        
        // 1. 태그 필터 적용: 선택된 태그가 있으면 tags 필드에 대해 arrayContainsAny 조건 적용
        if !selectedTags.isEmpty {
            baseQuery = baseQuery.whereField("tags", arrayContainsAny: selectedTags)
        }
        
        // 2. 검색어가 있을 경우: 두 쿼리를 별도로 실행 후 결과를 병합 (OR 조건)
        if let searchText = searchText, !searchText.isEmpty {
            // Query 1: searchKeywords 필드에 대해 arrayContains 조건
            let keywordQuery = baseQuery.whereField("searchKeywords", arrayContains: searchText)
            
            // Query 2: title 필드에 대해 prefix 조건 (searchText로 시작하는 경우)
            let titleQuery = baseQuery
                .whereField("title", isGreaterThanOrEqualTo: searchText)
                .whereField("title", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            
            // DispatchGroup을 사용하여 두 쿼리를 병렬로 실행하고 결과를 병합
            let dispatchGroup = DispatchGroup()
            var postsDict: [String: Post] = [:]   // document id를 key로 사용하여 중복 제거
            var queryError: Error?
            
            // Query 1 실행
            dispatchGroup.enter()
            keywordQuery.getDocuments { snapshot, error in
                if let error = error {
                    queryError = error
                } else if let snapshot = snapshot {
                    for document in snapshot.documents {
                        if let post = try? document.data(as: Post.self), let id = post.id {
                            postsDict[id] = post
                        }
                    }
                }
                dispatchGroup.leave()
            }
            
            // Query 2 실행
            dispatchGroup.enter()
            titleQuery.getDocuments { snapshot, error in
                if let error = error {
                    queryError = error
                } else if let snapshot = snapshot {
                    for document in snapshot.documents {
                        if let post = try? document.data(as: Post.self), let id = post.id {
                            postsDict[id] = post
                        }
                    }
                }
                dispatchGroup.leave()
            }
            
            // 두 쿼리 모두 완료되면 결과 반환
            dispatchGroup.notify(queue: .main) {
                if let error = queryError {
                    completion(.failure(error))
                } else {
                    let combinedPosts = Array(postsDict.values)
                    completion(.success(combinedPosts))
                }
            }
            
        } else {
            // 3. 검색어가 없는 경우: 태그 필터만 적용된 상태에서 작성일 기준 내림차순 정렬
            baseQuery = baseQuery.order(by: "createdAt", descending: true)
            baseQuery.getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let posts = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
                    completion(.success(posts))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
    
    // MARK: - Helper
    /// 키워드를 저장하기 위한 메서드
    func generateSearchKeywords(from title: String) -> [String] {
        var keywords: Set<String> = []
        
        // 1. 공백 기준으로 분리된 단어 조합 생성
        let words = title.split(separator: " ").map { String($0) }
        if !words.isEmpty {
            // 연속된 단어 조합 모두 추가 (예: "검색", "검색 예시", "검색 예시 프로젝트")
            for i in 0..<words.count {
                var combined = ""
                for j in i..<words.count {
                    combined += words[j] + " "
                    let trimmed = combined.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        keywords.insert(trimmed)
                    }
                }
            }
        }
        
        // 2. 전체 제목(공백 제거)에서 4글자 n-gram 생성
        let titleWithoutSpaces = title.replacingOccurrences(of: " ", with: "")
        let n = 4
        if titleWithoutSpaces.count >= n {
            for i in 0...titleWithoutSpaces.count - n {
                let start = titleWithoutSpaces.index(titleWithoutSpaces.startIndex, offsetBy: i)
                let end = titleWithoutSpaces.index(start, offsetBy: n)
                let ngram = String(titleWithoutSpaces[start..<end])
                keywords.insert(ngram)
            }
        } else if !titleWithoutSpaces.isEmpty {
            // 만약 전체 제목 길이가 n보다 짧다면 전체 문자열을 추가
            keywords.insert(titleWithoutSpaces)
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
}
