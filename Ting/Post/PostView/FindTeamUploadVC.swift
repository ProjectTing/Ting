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
    
    let postType: PostType = .findTeam
    
    override func loadView() {
        self.view = uploadView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    
    /// TODO - 버튼액션 로직 정리 필요
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
        uploadView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
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
    
    @objc private func submitButtonTapped() {
        /// TODO - 정리 필요
        guard let title = uploadView.titleSection.textField.text, !title.isEmpty,
              let detail = uploadView.detailTextView.text, !detail.isEmpty,
              !uploadView.positionSection.getSelectedTags().isEmpty,
              !uploadView.availableSection.getSelectedTags().isEmpty,
              !uploadView.ideaStatusSection.getSelectedTags().isEmpty,
              !uploadView.teamSizeSection.getSelectedTags().isEmpty,
              !uploadView.meetingStyleSection.getSelectedTags().isEmpty,
              !uploadView.currentStatusSection.getSelectedTags().isEmpty else {
            let alert = UIAlertController(title: "입력 필요", message: "빈칸을 채워주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let post = Post(
            nickName: "현재 사용자 닉네임", // TODO: 실제 사용자 정보로 대체
            postType: postType.title,
            title: title,
            detail: detail,
            position: uploadView.positionSection.getSelectedTags(),
            techStack: uploadView.techStackTextField.textField.text?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) } ?? [],  // 기술 스택 문자열을 배열로 변환
            ideaStatus: uploadView.ideaStatusSection.getSelectedTag(),
            meetingStyle: uploadView.meetingStyleSection.getSelectedTag(),
            numberOfRecruits: uploadView.teamSizeSection.getSelectedTag(),
            createdAt: Date(),
            available: uploadView.availableSection.getSelectedTag(),
            currentStatus: uploadView.currentStatusSection.getSelectedTag()
        )
        
        // 서버에 업로드
        PostService.shared.uploadPost(post: post) { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("업로드 실패: \(error)")
            }
        }
    }
}
