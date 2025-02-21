//
//  FirstViewController.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//

import UIKit

/// PermissionView를 관리하는 뷰컨트롤러
class PermissionVC: UIViewController {

    private let permissionView = PermissionView()
    private let viewModel = PermissionVM() // ViewModel 추가

    // SignUpVC에서 약관 동의 후 동작할 클로저 추가
    var onAgreementCompletion: (() -> Void)?

    override func loadView() {
        self.view = permissionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        bindViewModel()
    }

    // "다음" 버튼 클릭 이벤트 설정
    private func setupActions() {
        permissionView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // "다음" 버튼이 눌렸을 때 실행될 메서드
    @objc private func nextButtonTapped() {
        let termsModalVC = TermsModalViewController()
        termsModalVC.modalPresentationStyle = .overFullScreen
        termsModalVC.modalTransitionStyle = .crossDissolve
        termsModalVC.delegate = self

        present(termsModalVC, animated: true, completion: nil)
    }
    
    // MARK: - ViewModel과 바인딩
    private func bindViewModel() {
        viewModel.onAgreementCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true) {
                    self?.onAgreementCompletion?() // SignUpVC에서 실행될 클로저 호출
                }
            }
        }
    }
}

// MARK: - TermsModalViewControllerDelegate
extension PermissionVC: TermsModalViewControllerDelegate {
    func didCompleteTermsAgreement() {
        viewModel.saveTermsAgreement() // Firestore 업데이트 로직을 ViewModel에서 실행
    }
}
