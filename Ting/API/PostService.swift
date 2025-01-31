
import FirebaseFirestore

class PostService {
    static let shared = PostService()
    private let db = Firestore.firestore()
    private init() {}
    
    func uploadPost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(post) // Firestore에 저장할 수 있는 형태로 인코딩
            db.collection("posts").addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    /// TODO - 페이징 처리, 제한갯수 설정 필요
    func getPostList(type: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection("posts")
            .whereField("postType", isEqualTo: type)
            /// TODO - 최신순 정렬 하는 방법 더 알아보기
            // .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.compactMap { document -> Post? in
                    try? document.data(as: Post.self)
                }
                completion(.success(posts))
            }
    }
}

