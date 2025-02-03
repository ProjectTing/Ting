//
//  ReportModel.swift
//  Ting
//
//  Created by 유태호 on 2/1/25.
//

struct ReportModel {
    var postInfo: Observable<PostInfo>
    var reportReason: Observable<ReportReason?>
    var description: Observable<String>
    
    struct PostInfo {
        let title: String
        let author: String
        let date: String
    }
}

enum ReportReason {
    case spam
    case harm
    case abuse
    case privacy
    case inappropriate
    case etc
    
    var description: String {
        switch self {
        case .spam: return "스팸/홍보성 게시글"
        case .harm: return "위험 정보"
        case .abuse: return "욕설/비방"
        case .privacy: return "개인정보 노출"
        case .inappropriate: return "음란성/선정성"
        case .etc: return "기타"
        }
    }
}

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
