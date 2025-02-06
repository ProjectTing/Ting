//
//  FirstViewController.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//

import UIKit

/// PermissionView를 관리하는 뷰컨트롤러
class PermissionVC: UIViewController {

    // PermissionView 사용
    private let permissionView = PermissionView()

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
        // 약관 동의 완료 후 SignUpViewController로 이동
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

