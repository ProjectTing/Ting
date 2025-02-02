//
//  FindTeamUploadVM.swift
//  Ting
//
//  Created by Watson22_YJ on 2/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class FindTeamUploadVM {

    let postService = PostService()
    
    // MARK: - Input
    let selectedPosition = BehaviorRelay<String>(value: "")  // 단일 선택으로 변경
    let selectedIdeaStatus = BehaviorRelay<String>(value: "")
    let selectedTeamSize = BehaviorRelay<String>(value: "")
    let selectedMeetingStyle = BehaviorRelay<String>(value: "")
    let selectedAvailable = BehaviorRelay<String>(value: "")
    let selectedCurrentStatus = BehaviorRelay<String>(value: "")
    
    let techStackInput = BehaviorRelay<[String]>(value: [])
    let titleInput = BehaviorRelay<String>(value: "")
    let detailInput = BehaviorRelay<String>(value: "")
    
    /// TODO - 포스트 생성 로직 고민
    func createPost() -> Post {
        let post = Post(
            id: nil,
            nickName: "테스트",
            postType: PostType.findTeam.title,
            title: titleInput.value,
            detail: detailInput.value,
            position: [selectedPosition.value],  // 단일 선택이므로 배열로 변환
            techStack: techStackInput.value,
            ideaStatus: selectedIdeaStatus.value,
            meetingStyle: selectedMeetingStyle.value,
            numberOfRecruits: selectedTeamSize.value,
            createdAt: Date(),
            urgency: nil,
            experience: nil,
            available: selectedAvailable.value,
            currentStatus: selectedCurrentStatus.value
        )
        return post
    }
    
    func submitButtonTapped() {
        let post = createPost()
        
        postService.uploadPost(post: post) { result in
            switch result {
            case .success:
                print("포스트 업로드 성공")
            case .failure(let error):
                print("포스트 업로드 실패: \(error)")
            }
        }
    }
}
