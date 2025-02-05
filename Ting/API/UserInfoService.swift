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
}

