//
//  JoinTeamUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀 합류 글 작성 VC
import UIKit
import SnapKit

final class JoinTeamUploadVC: UIViewController {
    
    let uploadView = JoinTeamUploadView()
    
    let postType: PostType = .joinTeam
    
    // 버튼 타이틀 담을 변수
    var selectedPositions: [String] = []
    var selectedAvailable = ""
    var selectedIdeaStatus = ""
    var selectedTeamSize = ""
    var selectedMeetingStyle = ""
    var selectedCurrentStatus = ""
    
    override func loadView() {
        self.view = uploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupSubmitButton()
    }
    
    private func setupDelegates() {
        uploadView.positionSection.delegate = self
        uploadView.availableSection.delegate = self
        uploadView.ideaStatusSection.delegate = self
        uploadView.teamSizeSection.delegate = self
        uploadView.meetingStyleSection.delegate = self
        uploadView.currentStatusSection.delegate = self
    }
    
    private func setupSubmitButton() {
        uploadView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func submitButtonTapped() {
        // 버튼 및 텍스트 입력 검사
        guard !selectedPositions.isEmpty,
              !selectedAvailable.isEmpty,
              !selectedIdeaStatus.isEmpty,
              !selectedTeamSize.isEmpty,
              !selectedMeetingStyle.isEmpty,
              !selectedCurrentStatus.isEmpty,
              // 텍스트 필드 입력 확인
              let techInput = uploadView.techStackTextField.textField.text,
              !techInput.isEmpty,
              let titleInput = uploadView.titleSection.textField.text,
              !titleInput.isEmpty,
              let detailInput = uploadView.detailTextView.text,
              !detailInput.isEmpty else {
            basicAlert(title: "입력 필요", message: "빈칸을 채워주세요")
            return
        }
        
        let techArray = techInput.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        // Post 생성 및 업로드
        let post = Post(
            id: nil,
            nickName: "test",
            postType: postType.rawValue,
            title: titleInput,
            detail: detailInput,
            position: selectedPositions,
            techStack: techArray,
            ideaStatus: selectedIdeaStatus,
            meetingStyle: selectedMeetingStyle,
            numberOfRecruits: selectedTeamSize,
            createdAt: Date(),
            urgency: nil,
            experience: nil,
            available: selectedAvailable,
            currentStatus: selectedCurrentStatus
        )
        // 서버에 업로드
        PostService.shared.uploadPost(post: post) { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.basicAlert(title: "업로드 실패", message: "\(error)")
            }
        }
    }
}

// 커스텀 섹션 버튼 delegate 프로토콜
extension JoinTeamUploadVC: LabelAndTagSectionDelegate {
    func selectedButton(in view: LabelAndTagSection, button: CustomTag) {
        // 버튼의 타이틀 가져오기
        guard let title = button.titleLabel?.text, let section = view.sectionType else { return }

        // 각 섹션별로 분기 처리
        switch section {
        case .position:
            selectedPositions = view.selectedTitles
        case .urgency:
            break
        case .ideaStatus:
            selectedIdeaStatus = title
        case .numberOfRecruits:
            selectedTeamSize = title
        case .meetingStyle:
            selectedMeetingStyle = title
        case .experience:
            break
        case .available:
            selectedAvailable = title
        case .currentStatus:
            selectedCurrentStatus = title
        }
    }
}
