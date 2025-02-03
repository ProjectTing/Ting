//
//  DetailViewModel.swift
//  Ting
//
//  Created by 유태호 on 2/2/25.
//

class DetailViewModel {
    private var model: DetailModel
    
    var postInfo: DetailModel.Observable<DetailModel.PostInfo> {
        return model.postInfo
    }
    
    var isCurrentUser: DetailModel.Observable<Bool> {
        return model.isCurrentUser
    }
    
    init() {
        self.model = DetailModel()
    }
    
    func deletePost(completion: @escaping (Bool) -> Void) {
        // Firebase 연동 시 구현
        completion(true)
    }
    
    func loadPostInfo() {
        // Firebase 연동 시 구현
        let postInfo = DetailModel.PostInfo(
            title: "프론트엔드 개발자 구직중",
            activityTime: "활동 가능 상태",
            availableTime: "풀펫 참여 가능 시간",
            timeState: "풀펫 참여 가능 시간",
            urgency: "여유로움",
            statusTags: ["온라인", "경력 2년", "실무 경험", "기죅자 구완", "디자이너 구완"],
            techStacks: ["React", "Swift", "Node.js", "Flutter", "Next.js", "git", "Nest.JS", "Vue.js", "React Native"],
            projectTypes: ["포트폴리오", "사이드 프로젝트"],
            description: "협업을 통해 함께 성장하고 싶습니다. \n\n열정적인 팀원들과 함께 의미있는 프로젝트를 만들어가고 싶습니다. \n\n실제 서비스  런칭 경험을 쌓고 싶으며, 체계적인 프로젝트 진행을 선호합니다."
        )
        model.postInfo.value = postInfo
    }
    
    func checkCurrentUser() {
        // Firebase 연동 시 구현
        // 현재 사용자가 게시글 작성자인지 확인
        model.isCurrentUser.value = true
    }
}
