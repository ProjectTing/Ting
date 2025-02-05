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
    
    // Create
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

