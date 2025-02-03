//
//  ReportViewModel.swift
//  Ting
//
//  Created by 유태호 on 2/1/25.
//

class ReportViewModel {
    private var model: ReportModel
    var isValidReport: Observable<Bool>
    let placeholderText = "신고 사유에 대해 자세히 설명해주세요"
    
    // MARK: - Public Properties
    var postInfo: Observable<ReportModel.PostInfo> {
        return model.postInfo
    }
    
    var reportReason: Observable<ReportReason?> {
        return model.reportReason
    }
    
    var description: Observable<String> {
        return model.description
    }
    
    // MARK: - Initialization
    init() {
        self.model = ReportModel(
            postInfo: Observable(ReportModel.PostInfo(title: "", author: "", date: "")),
            reportReason: Observable(nil),
            description: Observable("")
        )
        self.isValidReport = Observable(false)
        
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        model.reportReason.bind { [weak self] _ in
            self?.validateReport()
        }
        
        model.description.bind { [weak self] _ in
            self?.validateReport()
        }
    }
    
    private func validateReport() {
        isValidReport.value = model.reportReason.value != nil &&
                            !model.description.value.isEmpty &&
                            model.description.value != placeholderText
    }
    
    // MARK: - Public Methods
    func selectReason(_ reason: ReportReason) {
        model.reportReason.value = reason
    }
    
    func updateDescription(_ text: String) {
        model.description.value = text
    }
    
    func loadPostInfo(postId: String) {
        // Firebase 연동 시 구현
        let postInfo = ReportModel.PostInfo(
            title: "신고할 게시글 제목",
            author: "본인 이름or닉네임",
            date: "당일 날짜"
        )
        model.postInfo.value = postInfo
    }
    
    func submitReport(completion: @escaping (Bool) -> Void) {
        // Firebase 연동 시 구현
        completion(true)
    }
}
