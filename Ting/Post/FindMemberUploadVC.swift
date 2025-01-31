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
    
    let postType: PostType = .findMember
    
    override func loadView() {
        self.view = uploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    /// TODO - 버튼액션 로직 정리 필요
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
    }
    
    /// ⭐️ TODO - 로직, 모델 정리 필요
    @objc private func submitButtonTapped() {
        /// 필수 입력값 검증
        guard let title = uploadView.titleSection.textField.text, !title.isEmpty,
              let detail = uploadView.detailTextView.text, !detail.isEmpty,
              !uploadView.positionSection.getSelectedTags().isEmpty else {
            let alert = UIAlertController(title: "입력 필요", message: "빈칸을 채워주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        /// TODO - 코드 정리 필요 , 퀄리티 등
        /// Post 객체 생성
        let post = Post(
            nickName: "현재 사용자 닉네임", // TODO: 실제 사용자 정보로 대체
            postType: postType.title,
            title: title,
            detail: detail,
            position: uploadView.positionSection.getSelectedTags(), // 다중 선택 가능
            techStack: uploadView.teckstackTextField.textField.text?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) } ?? [],  // 기술 스택 문자열을 배열로 변환
            ideaStatus: uploadView.ideaStatusSection.getSelectedTag(),
            meetingStyle: uploadView.meetingStyleSection.getSelectedTag(),
            numberOfRecruits: uploadView.recruitsSection.getSelectedTag(),
            createdAt: Date(),
            urgency: uploadView.urgencySection.getSelectedTag(),
            experience: uploadView.experienceSection.getSelectedTag()
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
