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
    
    weak var delegate: PostUpdateDelegate?
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
                    numberOfRecruits: selectedRecruits,
                    createdAt: Date(),
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
                            // delegate를 통해 수정된 포스트 전달
                            self?.delegate?.didUpdatePost(post)
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
                            if let navigationController = self?.navigationController,
                               let postListVC = navigationController.viewControllers.first(where: { $0 is PostListVC }) as? PostListVC {
                                postListVC.loadInitialData()
                            }
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
