//
//  FirstViewController.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//

import UIKit

/// PermissionView를 관리하는 뷰컨트롤러
class PermissionVC: UIViewController {

    // FirstView를 사용
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
        let termsVC = TermsViewController()
        if let sheet = termsVC.sheetPresentationController {
            sheet.detents = [.medium()] // 반절 크기 모달
            sheet.prefersGrabberVisible = true // 위로 당길 수 있는 손잡이 표시
        }
        present(termsVC, animated: true, completion: nil)
    }
}
