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
    
    // 유저정보 신규 저장 로직
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
    
    // 중복 닉네임 확인 로직
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
    
    // Read
    func fetchUserInfo(completion: @escaping (Result<UserInfo, Error>) -> Void) {
        db.collection("infos").document("8zfZJghK37UzTeBYzIyJ") // 특정 사용자 문서를 참조
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let snapshot = snapshot, snapshot.exists else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                    return
                }
                do {
                    // Firestore에서 UserInfo 객체로 변환
                    let userInfo = try snapshot.data(as: UserInfo.self)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
}

