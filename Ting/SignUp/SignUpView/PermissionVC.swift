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

    // 약관 동의 완료 시 호출할 콜백 설정 (외부에서 설정 가능)
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
        print("약관 동의가 완료되었습니다.")

        // 현재 PermissionVC를 닫고 콜백 호출로 다음 화면으로 이동
        dismiss(animated: true) { [weak self] in
            self?.onAgreementCompletion?()
        }
    }
}
