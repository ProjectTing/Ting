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
    func getPostList(type: String, lastDocument: DocumentSnapshot?, completion: @escaping (Result<([Post], DocumentSnapshot?), Error>) -> Void) {
        
        var query = db.collection("posts")
        /// 조건설정 : posts의 postType이 파라미터의 type과 같은것을
            .whereField("postType", isEqualTo: type)
        /// 오더 - createdAt 을 내림차순으로 정렬해서
            .order(by: "createdAt", descending: true)
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
    
    func deletePost(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("posts").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    /// 검색 메서드
    func searchPosts(searchText: String?, selectedTags: [String], completion: @escaping (Result<[Post], Error>) -> Void) {
        
        var query: Query = db.collection("posts")
        
        // 1. 필터 적용: 선택된 태그가 있을 경우, tags 배열에 하나라도 포함되어 있는 게시글을 조회
        if !selectedTags.isEmpty {
            // arrayContainsAny는 최대 10개 요소까지 허용됨을 주의!
            query = query.whereField("tags", arrayContainsAny: selectedTags)
        }
        
        // 2. 검색어 적용: 예시로 title 필드에서 검색어가 포함된 게시글을 찾기 위한 prefix 검색
        if let searchText = searchText, !searchText.isEmpty {
            // Firestore에서는 부분 문자열 검색은 지원하지 않으므로, prefix 검색을 사용하는 방법
            // 먼저 title 필드에 대해 인덱스를 만들어야 하며, 아래와 같이 startAt, endAt을 활용
            query = query.whereField("searchKeywords", arrayContains: searchText)
        } else {
            // 검색어가 없는 경우, 작성일 기준 내림차순 정렬
            query = query.order(by: "createdAt", descending: true)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            let posts = documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            }
            completion(.success(posts))
        }
    }
    
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
}
