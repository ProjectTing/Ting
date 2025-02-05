//
//  UserInfo.swift
//  Ting
//
//  Created by 이재건 on 2/4/25.
//

import FirebaseFirestore

// 회원정보 추가 구조체
struct UserInfo: Identifiable, Codable {
    // 공통 필드 (필수)
    @DocumentID var id: String? // Firestore 문서 ID (자동 생성)
    
    let nickName: String  // User 모델 생성 시 User 타입으로 변경 or userID로 변경
    let techStack: String
    let tool: String
    let workStyle: String
    let location: String
    let interest: String
}

// Create
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
