//
//  PostListVM.swift
//  Ting
//
//  Created by Watson22_YJ on 2/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PostListVM {
    
    private let postService = PostService()
    let postType: PostType
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    let modelSelected = PublishRelay<Post>()
    
    // MARK: - Output
    let posts = BehaviorRelay<[Post]>(value: [])
    
    init(type: PostType) {
        self.postType = type
    }
    
    func fetchPosts() {
        postService.getPostList(type: postType.title)
            .subscribe(
                onSuccess: { [weak self] posts in
                    self?.posts.accept(posts)
                },
                onFailure: { error in
                    print("Error: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}
