//
//  JoinTeamUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀 합류 글 작성 VC
import UIKit
import SnapKit

protocol PostListUpdater: AnyObject {
    func didUpdatePostList()
}

protocol PostUpdateDelegate: AnyObject {
    func didUpdatePost(_ updatedPost: Post)
}

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
    
    weak var updateDelegate: PostUpdateDelegate?
    weak var listDelegate: PostListUpdater?
    var isEditMode = false
    var editPostId: String?
    
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
        print("➡️ JoinTeamUploadVC - submitButtonTapped() called")
        
        // 버튼 및 텍스트 입력 검사
        guard !selectedPositions.isEmpty,
              !selectedAvailable.isEmpty,
              !selectedIdeaStatus.isEmpty,
              !selectedTeamSize.isEmpty,
              !selectedMeetingStyle.isEmpty,
              !selectedCurrentStatus.isEmpty,
              let techInput = uploadView.techStackTextField.textField.text,
              !techInput.isEmpty,
              let titleInput = uploadView.titleSection.textField.text,
              !titleInput.isEmpty,
              let detailInput = uploadView.detailTextView.text,
              !detailInput.isEmpty else {
            basicAlert(title: "입력 필요", message: "빈칸을 채워주세요")
            return
        }
        
        // UserDefaults에서 userId 확인
        guard UserDefaults.standard.string(forKey: "userId") != nil else { return }
        
        // 사용자 정보 가져오기
        UserInfoService.shared.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userInfo):
                
                let techArray = techInput.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                let keywords = PostService.shared.generateSearchKeywords(from: titleInput)
                
                let post = Post(
                    id: nil,
                    nickName: userInfo.nickName,
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
                    currentStatus: selectedCurrentStatus,
                    tags: [postType.rawValue, selectedMeetingStyle] + selectedPositions,
                    searchKeywords: keywords
                )
                
                if isEditMode {
                    guard let postId = editPostId else { return }
                    PostService.shared.updatePost(id: postId, post: post) { [weak self] result in
                        switch result {
                        case .success:
                            // 업데이트 성공 시 delegate로 수정된 post 전달
                            self?.listDelegate?.didUpdatePostList()
                            self?.updateDelegate?.didUpdatePost(post)
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            print("\(error)")
                            self?.basicAlert(title: "수정 실패", message: "")
                        }
                    }
                    
                } else {
                    PostService.shared.uploadPost(post: post) { [weak self] result in
                        switch result {
                        case .success:
                            self?.listDelegate?.didUpdatePostList()
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            print("\(error)")
                            self?.basicAlert(title: "업로드 실패", message: "")
                        }
                    }
                }
                
            case .failure(let error):
                print("\(error)")
                self.basicAlert(title: "사용자 정보 조회 실패", message: "")
                
            }
        }
    }
}

// 커스텀 섹션 버튼 delegate 프로토콜
extension JoinTeamUploadVC: LabelAndTagSectionDelegate {
    func selectedButton(in view: LabelAndTagSection, button: CustomTag, isSelected: Bool) {
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
