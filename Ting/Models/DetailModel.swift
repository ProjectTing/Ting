//
//  DetailModel.swift
//  Ting
//
//  Created by 유태호 on 2/2/25.
//

struct DetailModel {
    // Observable을 DetailModel 내부에 중첩 타입으로 선언
    class Observable<T> {
        var value: T {
            didSet {
                listener?(value)
            }
        }
        
        private var listener: ((T) -> Void)?
        
        init(_ value: T) {
            self.value = value
        }
        
        func bind(_ listener: @escaping (T) -> Void) {
            self.listener = listener
            listener(value)
        }
    }
    
    struct PostInfo {
        let title: String
        let activityTime: String
        let availableTime: String
        let timeState: String
        let urgency: String
        let statusTags: [String]
        let techStacks: [String]
        let projectTypes: [String]
        let description: String
    }
    
    var postInfo: Observable<PostInfo>
    var isCurrentUser: Observable<Bool>
    
    init() {
        self.postInfo = Observable(PostInfo(
            title: "프론트엔드 개발자 구직중",
            activityTime: "활동 가능 상태",
            availableTime: "풀펫 참여 가능 시간",
            timeState: "풀펫 참여 가능 시간",
            urgency: "여유로움",
            statusTags: ["온라인", "경력 2년", "실무 경험", "기죅자 구완", "디자이너 구완"],
            techStacks: ["React", "Swift", "Node.js", "Flutter", "Next.js", "git", "Nest.JS", "Vue.js", "React Native"],
            projectTypes: ["포트폴리오", "사이드 프로젝트"],
            description: "협업을 통해 함께 성장하고 싶습니다. \n\n열정적인 팀원들과 함께 의미있는 프로젝트를 만들어가고 싶습니다. \n\n실제 서비스  런칭 경험을 쌓고 싶으며, 체계적인 프로젝트 진행을 선호합니다."
        ))
        self.isCurrentUser = Observable(false)
    }
}
