//
//  PostUploadVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

/// 파일 삭제 예정 -> FindMember,FindTeam 두개로 나눔
final class PostUploadVC: UIViewController {
    
    private let postUploadView = PostUploadView()
    
    // 선택된 버튼들을 추적하기 위한 프로퍼티, 중복선택 관련
    private var selectedPositions: Set<String> = []
    
    override func loadView() {
        self.view = postUploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    // 모든 스택뷰의 버튼들에 대해 addTarget 설정
    private func setupTagButtonActions() {
        for (stackView, _) in postUploadView.stackViewsWithTitles {
            for view in stackView.arrangedSubviews {
                if let button = view as? CustomTag {
                    button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
                }
            }
        }
    }
    
    // 태그 클릭 관련
    @objc private func tagButtonTapped(_ sender: CustomTag) {
        guard let stackView = sender.superview as? UIStackView,
              let title = sender.titleLabel?.text else { return }
        
        // 직무 스택뷰인 경우 (다중 선택 가능)
        if stackView == postUploadView.positionButtonStack {
            sender.isSelected.toggle()
            if sender.isSelected {
                selectedPositions.insert(title)
            } else {
                selectedPositions.remove(title)
            }
            return
        }
        
        // 나머지 스택뷰들 (단일 선택)
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? CustomTag, button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected.toggle()
    }
}
