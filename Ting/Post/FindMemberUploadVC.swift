//
//  FindMemberUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀원 구함 글 작성 VC
import UIKit
import SnapKit

final class FindMemberUploadVC: UIViewController {
    
    private let uploadView = FindMemberUploadView()

    // 선택된 태그 관리
    private var selectedTags: [CustomTag] = []
    
    override func loadView() {
        self.view = uploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    private func setupTagButtonActions() {
         // 모든 섹션의 버튼에 동일한 액션 적용
        let allSections = [
            uploadView.positionSection,
            uploadView.urgencySection,
            uploadView.ideaStatusSection,
            uploadView.recruitsSection,
            uploadView.meetingStyleSection,
            uploadView.experienceSection
        ]
        
        for section in allSections {
            for button in section.getTagButtons() {
                button.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            }
        }

        uploadView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
     @objc private func tagButtonTapped(_ sender: CustomTag) {
        // 버튼이 속한 스택뷰와 섹션 찾기
        guard let stackView = sender.superview as? UIStackView,
              let section = sender.superview?.superview as? LabelAndTagStackView else { return }
        
        if !section.isDuplicable {
            // 단일 선택인 경우 같은 스택뷰 내의 다른 버튼들 선택 해제
            stackView.arrangedSubviews.forEach { view in
                if let button = view as? CustomTag, button != sender {
                    button.isSelected = false
                }
            }
        }
        
        sender.isSelected.toggle()
        
        // 선택된 태그 관리
        if sender.isSelected {
            // 선택된 태그 추가
            selectedTags.append(sender)
        } else {
            // 선택 해제되면 배열에서 삭제
            selectedTags.removeAll { $0 == sender }
        }
    }
    
    // 제출 버튼 클릭 시 모든 내용 출력 테스트 -
    /// TODO - 모델 구조체로 변환 후 서버에 전송 예정, 작성후 게시글 상세 페이지로 데이터 전달+ 화면 띄우기
    @objc private func submitButtonTapped() {
        let selectedTagTitles = selectedTags.map { $0.titleLabel?.text ?? "" }
        print(selectedTagTitles)
        print(uploadView.teckstackTextField.textField.text ?? "기술 스택 없음")
        print(uploadView.titleSection.textField.text ?? "제목 없음")
        print(uploadView.detailTextView.text ?? "내용 없음")
    }
}
