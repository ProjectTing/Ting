//
//  PermissionVM.swift
//  Ting
//
//  Created by Sol on 2/20/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PermissionVM {
    
    // 약관 동의 완료 시 실행할 클로저
    var onAgreementCompletion: (() -> Void)?
    
    /// 현재 로그인된 사용자 UID 가져오기
    private var userID: String? {
        return Auth.auth().currentUser?.uid
    }

    /// Firestore에 약관 동의 정보 저장
    func saveTermsAgreement() {
        guard let userID = userID else {
            print("현재 로그인된 사용자가 없습니다.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "termsAccepted": true
        ]) { [weak self] error in
            if let error = error {
                print("약관 동의 정보 저장 실패: \(error.localizedDescription)")
            } else {
                print("약관 동의 정보 저장 완료")
                
                DispatchQueue.main.async {
                    self?.onAgreementCompletion?() // UI 업데이트 콜백 실행
                }
            }
        }
    }
}
