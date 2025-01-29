//
//  FindTeamUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀 구함 글 작성 VC
import UIKit
import SnapKit

final class FindTeamUploadVC: UIViewController {
    private let uploadView = FindTeamUploadView()
    
    override func loadView() {
        self.view = uploadView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    private func setupTagButtonActions() {
        let sections = [
            uploadView.positionSection,
            uploadView.availableSection,
            uploadView.ideaStatusSection,
            uploadView.teamSizeSection,
            uploadView.meetingStyleSection,
            uploadView.currentStatusSection
        ]
        
        // 섹션 안에 모든 버튼들 addTarget설정
        for section in sections {
            for button in section.getTagButtons() {
                button.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc private func tagButtonTapped(_ sender: CustomTag) {
        // 버튼이 속한 스택뷰 찾기
    guard let buttonStack = sender.superview as? UIStackView else { return }
    
        // 같은 스택뷰 내의 다른 버튼들 선택 해제
        buttonStack.arrangedSubviews.forEach { view in
            if let button = view as? CustomTag, button != sender {
                button.isSelected = false
            }
        }

    // 현재 버튼 토글
    sender.isSelected.toggle()
    }
}
