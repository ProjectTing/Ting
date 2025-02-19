//
//  FirstViewController.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

/// PermissionView를 관리하는 뷰컨트롤러
class PermissionVC: UIViewController {

    private let permissionView = PermissionView()

    // SignUpVC에서 약관 동의 후 동작할 클로저 추가
    var onAgreementCompletion: (() -> Void)?

    override func loadView() {
        self.view = permissionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    // "다음" 버튼 클릭 이벤트 설정
    private func setupActions() {
        permissionView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // "다음" 버튼이 눌렸을 때 실행될 메서드
    @objc private func nextButtonTapped() {
        let termsModalVC = TermsModalViewController()
        termsModalVC.modalPresentationStyle = .overFullScreen  // 전체 화면을 덮는 모달
        termsModalVC.modalTransitionStyle = .crossDissolve     // 부드러운 전환 효과
        termsModalVC.delegate = self  // Delegate 패턴 추가

        present(termsModalVC, animated: true, completion: nil)
    }
}

// MARK: - TermsModalViewControllerDelegate
extension PermissionVC: TermsModalViewControllerDelegate {
    func didCompleteTermsAgreement() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("현재 로그인된 사용자가 없습니다.")
            return
        }

        // Firestore에 약관 동의 정보 저장
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "termsAccepted": true
        ]) { [weak self] error in
            if let error = error {
                print("약관 동의 정보 저장 실패: \(error.localizedDescription)")
            } else {
                print("약관 동의 정보 저장 완료")
                
                DispatchQueue.main.async {
                    self?.dismiss(animated: true) {
                        self?.onAgreementCompletion?() // SignUpVC에서 실행될 클로저 호출
                    }
                }
            }
        }
    }
}
