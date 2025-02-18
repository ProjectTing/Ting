//
//  RecruitMemberUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀원 모집 글 작성 VC
import UIKit
import SnapKit

final class RecruitMemberUploadVC: UIViewController {
    
    let uploadView = RecruitMemberUploadView()
    
    let postType: PostType = .recruitMember
    
    // 버튼 타이틀 담을 변수
    var selectedPositions: [String] = []
    var selectedUrgency = ""
    var selectedIdeaStatus = ""
    var selectedRecruits = ""
    var selectedMeetingStyle = ""
    var selectedExperience = ""
    
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
        uploadView.urgencySection.delegate = self
        uploadView.ideaStatusSection.delegate = self
        uploadView.recruitsSection.delegate = self
        uploadView.meetingStyleSection.delegate = self
        uploadView.experienceSection.delegate = self
        uploadView.titleSection.textField.delegate = self
        uploadView.techStackTextField.textField.delegate = self
    }
    
    // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        uploadView.endEditing(true)
    }
    
    private func setupSubmitButton() {
        uploadView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func submitButtonTapped() {
        
        // 버튼 및 텍스트 입력 검사
        guard !selectedPositions.isEmpty,
              !selectedUrgency.isEmpty,
              !selectedIdeaStatus.isEmpty,
              !selectedRecruits.isEmpty,
              !selectedMeetingStyle.isEmpty,
              !selectedExperience.isEmpty,
              let techInput = uploadView.techStackTextField.textField.text,
              !techInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let titleInput = uploadView.titleSection.textField.text,
              !titleInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let detailInput = uploadView.detailTextView.text,
              !detailInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            basicAlert(title: "입력 필요", message: "빈칸을 채워주세요")
            return
        }
        
        let techArray = techInput.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // 각 기술 스택 글자 수 검사
        if techArray.contains(where: { $0.count > 10 }) {
            basicAlert(title: "글자 수 초과", message: "기술 스택은 10글자 이하로 입력해주세요.")
            return
        }
        
        // UserDefaults에서 userId 확인
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        // 사용자 정보 가져오기
        UserInfoService.shared.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userInfo):
                
                let trimmedTitle = titleInput.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedDetail = detailInput.trimmingCharacters(in: .whitespacesAndNewlines)
                let keywords = PostService.shared.generateSearchKeywords(from: titleInput)
                
                let post = Post(
                    id: nil,
                    userId: userId,
                    nickName: userInfo.nickName,
                    postType: postType.rawValue,
                    title: trimmedTitle,
                    detail: trimmedDetail,
                    position: selectedPositions,
                    techStack: techArray,
                    ideaStatus: selectedIdeaStatus,
                    meetingStyle: selectedMeetingStyle,
                    numberOfRecruits: selectedRecruits,
                    createdAt: Date(),
                    reportCount: 0,  // 초기 신고 카운트는 0으로 설정
                    urgency: selectedUrgency,
                    experience: selectedExperience,
                    available: nil,
                    currentStatus: nil,
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
                                name: .postUpdated,
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
                            // 리스트 업데이트 알림 보내기
                            NotificationCenter.default.post(name: .postUpdated, object: nil)
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

// 커스텀 섹션 버튼 delegate패턴 활용, 프로토콜 채택
extension RecruitMemberUploadVC: LabelAndTagSectionDelegate {
    func selectedButton(in view: LabelAndTagSection, button: CustomTag, isSelected: Bool) {
        // 버튼의 타이틀 가져오기
        guard let title = button.titleLabel?.text, let section = view.sectionType else { return }
        
        // 각 섹션별로 분기 처리
        switch section {
        case .position:
            selectedPositions = view.selectedTitles
        case .urgency:
            selectedUrgency = title
        case .ideaStatus:
            selectedIdeaStatus = title
        case .numberOfRecruits:
            selectedRecruits = title
        case .meetingStyle:
            selectedMeetingStyle = title
        case .experience:
            selectedExperience = title
        case .available:
            break
        case .currentStatus:
            break
        }
    }
}

extension RecruitMemberUploadVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
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
