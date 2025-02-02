//
//  FindMemberUploadVM.swift
//  Ting
//
//  Created by Watson22_YJ on 2/1/25.
//

import Foundation
import RxSwift
import RxCocoa

class FindMemberUploadVM {

    let postService = PostService()
    
    // MARK: - Input
    let selectedPositions = BehaviorRelay<[String]>(value: [])
    let selectedUrgency = BehaviorRelay<String>(value: "")
    let selectedIdeaStatus = BehaviorRelay<String>(value: "")
    let selectedRecruits = BehaviorRelay<String>(value: "")
    let selectedMeetingStyle = BehaviorRelay<String>(value: "")
    let selectedExperience = BehaviorRelay<String>(value: "")
    
    let techStackInput = BehaviorRelay<[String]>(value: [])
    let titleInput = BehaviorRelay<String>(value: "")
    let detailInput = BehaviorRelay<String>(value: "")

    /// TODO - 포스트 생성 로직 고민
    func createPost() -> Post {
        let post = Post(
            id: nil,
            nickName: "테스트",
            postType: PostType.findMember.title,
            title: titleInput.value,
            detail: detailInput.value,
            position: selectedPositions.value,
            techStack: techStackInput.value,
            ideaStatus: selectedIdeaStatus.value,
            meetingStyle: selectedMeetingStyle.value,
            numberOfRecruits: selectedRecruits.value,
            createdAt: Date(),
            urgency: selectedUrgency.value,
            experience: selectedExperience.value,
            available: nil,
            currentStatus: nil
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

