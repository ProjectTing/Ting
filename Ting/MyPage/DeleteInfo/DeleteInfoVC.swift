//
//  EditInfoVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

class DeleteInfoVC: UIViewController {
    
    //MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "회원 탈퇴"
        $0.textColor = .brownText
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    // "제7조 (계약 해지 및 서비스 중단)"을 버튼으로 변경
    private lazy var policyDetailButton = UIButton().then {
        $0.setTitle("제7조 (계약 해지 및 서비스 중단)", for: .normal)
        $0.setTitleColor(.blue, for: .normal)  // 링크처럼 보이는 파란색 글자
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(policyDetailTapped), for: .touchUpInside)
    }
    
    private let policyTitle = UILabel().then {
        $0.text = "회원 탈퇴 안내"
        $0.textColor = .brownText
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let checkIcon = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle.fill")
        $0.tintColor = .grayCloud // 기본 비활성화 색상
        $0.isUserInteractionEnabled = true // 사용자 터치 가능하도록 설정
    }
    
    private let agreement = UILabel().then {
        $0.text = "약관을 확인했으며, 회원 탈퇴에 동의합니다"
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .deepCocoa
        $0.textAlignment = .left
    }
    
    // Firebase가 Apple의 idToken 검증 시 nonce 비교
    lazy var rawNonce: String = {
        return SignUpViewController.randomNonceString()
    }()
    
    // idToken 내부 해시값
    lazy var hashedNonce: String = {
        // self.rawNonce에 접근하여 해싱
        return SignUpViewController.sha256(self.rawNonce)
    }()
    
    // 현재 체크 상태 저장
    private var isChecked = false {
        didSet {
            checkIcon.tintColor = isChecked ? .accent : .grayCloud
            deleteBtn.isEnabled = isChecked  // 체크 상태에 따라 버튼 활성화
            deleteBtn.backgroundColor = isChecked ? .primary : .grayCloud  // 비활성화 시 색상 변경
        }
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [checkIcon, agreement]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillProportionally
    }
    
    private lazy var deleteBtn = UIButton().then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.backgroundColor = .grayCloud  // 초기에는 비활성화
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.isEnabled = false  // 초기에는 비활성화
        $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .primary // 네비게이션 바 Back버튼 컬러 변경
        
        configureUI()
        setupTapGesture()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20) // 상단에서 여백 증가
            $0.centerX.equalToSuperview() // 화면 중앙 정렬
            $0.width.equalToSuperview().inset(10) // 카드뷰 너비 조정 (직접 설정)
        }
        
        cardView.addSubview(policyTitle)
        policyTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        
        cardView.addSubview(policyDetailButton)
        policyDetailButton.snp.makeConstraints {
            $0.top.equalTo(policyTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
        
        // cardView 크기 자동 조정
        cardView.snp.makeConstraints {
            $0.bottom.equalTo(policyDetailButton.snp.bottom).offset(20)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        checkIcon.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        // 버튼 추가 및 위치 조정
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(50) // 버튼 높이 설정
        }
    }
    
    // 약관 보기 버튼 클릭 시 동작 (URL로 이동)
    @objc private func policyDetailTapped() {
        guard let url = URL(string: "https://docs.google.com/document/d/1TK664HgE71qhHrwNoSkDdw05Hpy5rSWPkJLOriAlKJE/edit?usp=sharing") else {
            print("유효하지 않은 URL")
            return
        }
        UIApplication.shared.open(url)
    }
    
    // 체크 아이콘에 클릭 이벤트 추가
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        checkIcon.addGestureRecognizer(tapGesture)
    }
    
    // 체크 상태 변경 (토글)
    @objc private func toggleCheck() {
        isChecked.toggle()
    }
    
    // MARK: - Button Actions
    @objc private func deleteBtnTapped() {
        // Apple 로그인 재인증 요청
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.nonce = hashedNonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func deleteFirebaseAccount(user: User) {
        let db = Firestore.firestore()
        
        // 1. users 컬렉션에서 유저 데이터 삭제
        db.collection("users").document(user.uid).delete()
        
        // 2. infos 컬렉션에서 해당 userId를 가진 문서 찾아서 삭제
        db.collection("infos").whereField("userId", isEqualTo: user.uid).getDocuments { snapshot, error in
            if let error = error {
                print("infos 문서 조회 실패: \(error.localizedDescription)")
                return
            }
            
            // 찾은 문서들을 일괄 삭제
            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            // 일괄 삭제 실행
            batch.commit { error in
                if let error = error {
                    print("infos 문서 삭제 실패: \(error.localizedDescription)")
                } else {
                    print("infos 문서 삭제 성공!")
                }
            }
        }
        
        // 3. Firebase Auth에서 계정 삭제
        user.delete { error in
            if let error = error {
                print("Firebase Auth 계정 삭제 실패: \(error.localizedDescription)")
            } else {
                print("Firebase Auth 계정 삭제 성공!")
                
                // 4. 회원 탈퇴 후 첫 화면으로 이동
                DispatchQueue.main.async {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        let signupVC = SignUpViewController()
                        let navigationController = UINavigationController(rootViewController: signupVC)
                        
                        sceneDelegate.window?.rootViewController = navigationController
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}

// ASAuthorizationControllerDelegate 확장
extension DeleteInfoVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // view.window가 존재하면 바로 반환
        if let window = self.view.window {
            return window
        }
        
        // view.window가 nil일 경우, 현재 연결된 window scene에서 첫 번째 window 반환
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window
        }
        
        // 모든 경우에 실패하면, 빈 UIWindow를 반환 (최후의 수단)
        return UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idToken = appleIDCredential.identityToken,
              let idTokenString = String(data: idToken, encoding: .utf8) else {
            print("Apple ID Token 추출 실패")
            return
        }
        
        // Firebase Credential 생성
        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: idTokenString,
            rawNonce: rawNonce
        )
        
        // 재인증 수행
        guard let user = Auth.auth().currentUser else {
            print("로그인된 유저가 없습니다.")
            return
        }
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                print("재인증 실패: \(error.localizedDescription)")
            }
            
            // 재인증 성공 시 계정 삭제 로직 실행
            self?.deleteFirebaseAccount(user: user)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 재인증 실패: \(error.localizedDescription)")
    }
}
