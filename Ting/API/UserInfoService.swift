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

            db.collection("infos")
                .whereField("userId", isEqualTo: userId) // infos 컬렉션에서 userId가 일치하는 문서 검색
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let document = snapshot?.documents.first else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "해당 userId를 찾을 수 없음."])))
                        return
                    }
                    
                    // 문서 ID로 업데이트
                    let documentId = document.documentID
                    do { // 일치하는 문서를 UserInfo 객체로 변환
                        let data = try Firestore.Encoder().encode(userInfo)
                        self.db.collection("infos").document(documentId).updateData(data) { error in
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
        }
}

