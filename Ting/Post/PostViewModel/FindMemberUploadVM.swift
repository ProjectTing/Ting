//
//  FindMemberUploadVM.swift
//  Ting
//
//  Created by Watson22_YJ on 2/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class FindMemberUploadVM {
    
    let postService = PostService()
    let disposeBag = DisposeBag()
    
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
    
    let submitButtonTap = PublishRelay<Void>()
    
    init() {
            bind()
        }
    
    /// TODO - 입력값 검증 필요 ( 빈값인지 )
    /// 업로드 에러 처리 필요
    func bind() {
        submitButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let post = self.createPost()
                self.postService.uploadPost(post: post)
                    .subscribe(
                        onCompleted: {
                            print("업로드 성공")
                        },
                        onError: { error in
                            print("업로드 실패: \(error)")
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
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
    
}

