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
    
    weak var delegate: PostListUpdater?
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
        uploadView.titleSection.textField.delegate = self
        uploadView.techStackTextField.textField.delegate = self
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
        !techInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
        let titleInput = uploadView.titleSection.textField.text,
        !titleInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
        let detailInput = uploadView.detailTextView.text,
        !detailInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            basicAlert(title: "입력 필요", message: "빈칸을 채워주세요")
            return
        }
        
        // UserDefaults에서 userId 확인
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        // 사용자 정보 가져오기
        UserInfoService.shared.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userInfo):
                
                let techArray = techInput.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                let keywords = PostService.shared.generateSearchKeywords(from: titleInput)
                
                let post = Post(
                    id: nil,
                    userId: userId,
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
                    reportCount: 0,  // 초기 신고 카운트는 0으로 설정
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
                            
                            // 데이터 최신화 업로드
                            NotificationCenter.default.post(
                                name: .userInfoUpdated,
                                object: nil
                            )
                            
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
                            self?.delegate?.didUpdatePostList()
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

extension JoinTeamUploadVC: UITextFieldDelegate {
    
    // 글자 수 제한 제목 20자 이하, 기술스택 30자 이하
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == uploadView.titleSection.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        } else {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 50
        }
    }
}
