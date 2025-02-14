//
//  UserInfoService.swift
//  Ting
//
//  Created by 이재건 on 2/5/25.
//

import FirebaseFirestore

class UserInfoService {
    static let shared = UserInfoService()
    private let db = Firestore.firestore()
    private init() {}
    
    // MARK: 유저정보 신규 저장 로직
    func createUserInfo(info: UserInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(info) // Firestore에 저장할 수 있는 형태로 인코딩
            db.collection("infos").addDocument(data: data) { error in
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
    
    // MARK: 중복 닉네임 확인 로직
    func checkNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> Void) {
        db.collection("infos").whereField("nickName", isEqualTo: nickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("닉네임 중복 확인 실패: \(error)")
                    completion(false)
                    return
                }
                completion(!(snapshot?.isEmpty ?? true))
            }
    }
    
    // MARK: 서버 데이터 Read 로직
    func fetchUserInfo(completion: @escaping (Result<UserInfo, Error>) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "UserDefaults에 저장된 userId 없음."])))
            return
        }
        db.collection("infos")
            .whereField("userId", isEqualTo: userId) // infos 컬렉션에서 userId가 일치하는 문서 검색
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "일치하는 유저가 없음."])))
                    return
                }
                do { // 일치하는 문서를 UserInfo 객체로 변환
                    if let document = documents.first {
                        let userInfo = try document.data(as: UserInfo.self)
                        completion(.success(userInfo))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "변환실패"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: 회원정보 수정 로직
    func updateUserInfo(userInfo: UserInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        // Firestore에서 userId로 해당 문서를 찾은 후 업데이트
        guard let userId = userInfo.userId else {
            completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "UserInfo에 userId가 없음."])))
            return
        }
        
        // 현재 사용자 정보를 가져와서 닉네임 변경 여부 확인
        fetchUserInfo { result in
            switch result {
            case .success(let currentUserInfo):
                let oldNickname = currentUserInfo.nickName
                let newNickname = userInfo.nickName
                
                // batch 작업 시작
                let batch = self.db.batch()
                
                // 1. infos 컬렉션에서 해당 유저 문서 찾기
                self.db.collection("infos")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let document = snapshot?.documents.first else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "해당 userId를 찾을 수 없음."])))
                        return
                    }
                    
                    do {
                        // 2. UserInfo 업데이트를 batch에 추가
                        let documentId = document.documentID
                        let data = try Firestore.Encoder().encode(userInfo)
                        let userDocRef = self.db.collection("infos").document(documentId)
                        batch.updateData(data, forDocument: userDocRef)
                        
                        // 3. 닉네임이 변경된 경우에만 posts 업데이트
                        if oldNickname != newNickname {
                            // posts 컬렉션에서 해당 닉네임의 모든 게시글 찾기
                            self.db.collection("posts")
                                .whereField("nickName", isEqualTo: oldNickname)
                                .getDocuments { postsSnapshot, postsError in
                                    if let postsError = postsError {
                                        completion(.failure(postsError))
                                        return
                                    }
                                    
                                    // 각 게시글의 닉네임 업데이트를 batch에 추가
                                    postsSnapshot?.documents.forEach { postDoc in
                                        let postRef = self.db.collection("posts").document(postDoc.documentID)
                                        batch.updateData(["nickName": newNickname], forDocument: postRef)
                                    }
                                    
                                    // 신고 관련 닉네임도 업데이트
                                    ReportManager.shared.updateReportNicknames(oldNickname: oldNickname, newNickname: newNickname) { result in
                                        switch result {
                                        case .success:
                                            // batch 커밋
                                            batch.commit { error in
                                                if let error = error {
                                                    completion(.failure(error))
                                                } else {
                                                    completion(.success(()))
                                                }
                                            }
                                        case .failure(let error):
                                            completion(.failure(error))
                                        }
                                    }
                                }
                        } else {
                            // 닉네임이 변경되지 않은 경우 바로 batch 커밋
                            batch.commit { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(()))
                                }
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension UserInfoService {
    /// 신고한 게시글 ID를 사용자 정보에 추가하는 메서드
    func addReportedPost(postId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // 현재 사용자 정보 가져오기
        fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var userInfo):
                // 신고한 게시글 목록 업데이트
                var reportedPosts = userInfo.reportedPosts ?? []
                if !reportedPosts.contains(postId) {
                    reportedPosts.append(postId)
                    userInfo.reportedPosts = reportedPosts
                    
                    // Firestore 문서 찾기
                    self.db.collection("infos")
                        .whereField("userId", isEqualTo: userInfo.userId ?? "")
                        .getDocuments { snapshot, error in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            
                            guard let document = snapshot?.documents.first else {
                                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                                return
                            }
                            
                            // reportedPosts 필드만 업데이트
                            self.db.collection("infos").document(document.documentID)
                                .updateData(["reportedPosts": reportedPosts]) { error in
                                    if let error = error {
                                        completion(.failure(error))
                                    } else {
                                        completion(.success(()))
                                    }
                                }
                        }
                } else {
                    completion(.success(())) // 이미 신고한 게시글이면 성공으로 처리
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 신고한 게시글 목록 확인 메서드
    func hasReportedPost(postId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                let hasReported = userInfo.reportedPosts?.contains(postId) ?? false
                completion(.success(hasReported))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
