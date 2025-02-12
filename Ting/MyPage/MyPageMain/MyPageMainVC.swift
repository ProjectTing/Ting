//
//  MyPageMainVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth

class MyPageMainVC: UIViewController {
    
    // MARK: - UI Components
    // 다양한 기종 대응하기 위해, 특히 소형기종 위해 스크롤뷰로 구현
    // 기본사이즈 이상, 플러스 맥스 사이즈에서는 스크롤 뷰 작동하지 않아도 정상 출력
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textAlignment = .left
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    // MARK: Section 1. 첫번째 카드뷰에 들어갈 내용들
    private let profileCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let nickName = UILabel().then {
        $0.text = "로그인이 필요합니다."
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    private let role = UILabel().then {
        $0.text = "로그인이 필요합니다."
        $0.textColor = .deepCocoa
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    private lazy var profileStack = UIStackView(arrangedSubviews: [nickName, role]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // MARK: Section 2. 두번째 카드뷰에 들어갈 내용들
    private let textFieldCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    // textField 항목들
    private let techStackField = MyPageCustomView(title: "기술 스택", detail: "예: Swift, Kotlin")
    private let toolField = MyPageCustomView(title: "사용 툴", detail: "예: Xcode, Android Studio")
    private let workStyleField = MyPageCustomView(title: "협업 방식", detail: "예: 온라인, 오프라인, 무관")
    private let locationField = MyPageCustomView(title: "지역", detail: "거주 지역을 입력하세요")
    private let interestField = MyPageCustomView(title: "관심사", detail: "관심 있는 분야를 입력하세요")
    
    private lazy var textFieldStack = UIStackView(arrangedSubviews: [
        techStackField,
        toolField,
        workStyleField,
        locationField,
        interestField
    ]).then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    // MARK: Section 3. Buttons
    private lazy var deleteBtn = UIButton(type: .system).then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .background
        $0.layer.borderColor = UIColor.accent.cgColor // 테두리 색 설정
        $0.layer.borderWidth = 1.5 // 테두리 두께 설정
        $0.setTitleColor(.accent, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }
    private lazy var editBtn = UIButton(type: .system).then {
        $0.setTitle("회원정보 수정", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .primaries
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
    }
    
    private lazy var btnStackView = UIStackView(arrangedSubviews: [deleteBtn, editBtn]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        configureUI()
        fetchUserData()
        
        // 알림 리스너 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserInfoUpdated), name: .userInfoUpdated, object: nil)
    }
    // MARK: - Notification Handler
    @objc private func handleUserInfoUpdated() {
        // 데이터 새로고침
        fetchUserData()
    }
    
    // MARK: - Navigation Bar 설정
    private func navigationBar() {
        let title = UILabel().then {
            $0.text = "마이페이지"
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textColor = .brownText
        }
        
        let logOutBtn = UIButton(type: .system).then {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.accent, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(logOutBtnTapped), for: .touchUpInside)
        }
        
        let titleItem = UIBarButtonItem(customView: title)
        let logOutBtnItem = UIBarButtonItem(customView: logOutBtn)
        
        navigationItem.leftBarButtonItem = titleItem
        navigationItem.rightBarButtonItem = logOutBtnItem
    }
    
    // MARK: - configure UI
    private func configureUI() {
        view.backgroundColor = .background
        
        // ScrollView (CardView만 스크롤 가능하게 설정)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80) // 저장 버튼 공간 확보
        }
        
        // ContentView 추가 (ScrollView 내부에 포함)
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // 가로 스크롤 방지
        }
        
        // profileCard (ScrollView 내부에 포함)
        contentView.addSubview(profileCard)
        profileCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        profileCard.addSubview(profileStack) // profileStack = 이름, 직군
        profileStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        // textFieldCard 추가 (ScrollView 내부에 포함)
        contentView.addSubview(textFieldCard)
        textFieldCard.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }
        textFieldCard.addSubview(textFieldStack) // textFieldStack = 텍스트 필드 항목들
        textFieldStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        // 회원탈퇴, 회원정보 수정 버튼 (고정)
        view.addSubview(btnStackView)
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        // 버튼 높이 설정
        editBtn.snp.makeConstraints {
            $0.height.equalTo(50) // 50으로 하면 짤림
        }
        deleteBtn.snp.makeConstraints {
            $0.height.equalTo(50) // 50으로 하면 짤림
        }
    }
    
    // MARK: - Firebase Data Fetching
    private func fetchUserData() {
        UserInfoService.shared.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    self.updateLabels(with: userInfo)
                    self.updateCustomViews(with: userInfo)
                }
            case .failure(let error):
                print("데이터 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    // profileCard 항목들에 추가
    private func updateLabels(with userInfo: UserInfo) {
        nickName.text = userInfo.nickName
        role.text = userInfo.role
    }
    // textFieldCard 항목들에 추가
    private func updateCustomViews(with userInfo: UserInfo) {
        techStackField.updateDetailText(userInfo.techStack)
        toolField.updateDetailText(userInfo.tool)
        workStyleField.updateDetailText(userInfo.workStyle)
        locationField.updateDetailText(userInfo.location)
        interestField.updateDetailText(userInfo.interest)
    }
    
    // MARK: - 로그아웃 로직
    private func performLogout() {
        do {
            // 1. Firebase 로그아웃
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil { //로그아웃 성공 여부 검증
                print("Firebase 로그아웃 성공")
            } else {
                print("Firebase 로그아웃 실패 - 여전히 currentUser 존재")
            }
            
            // 2. UserDefaults 정보 삭제
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.synchronize()
            print("UserDefaults 삭제 성공. | 삭제된 UserDefaults: ")
            
            // 3. 로그인 화면으로 이동
            let firstView = SignUpVC()
            let navController = UINavigationController(rootViewController: firstView)
            
            // 현재 창을 로그인 화면으로 변경
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
            }
        } catch let error {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - Button Actions
    @objc // 로그아웃 버튼 클릭
    private func logOutBtnTapped() {
        let logOutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.performLogout()
        }
        
        logOutAlert.addAction(cancelAction)
        logOutAlert.addAction(confirmAction)
        
        present(logOutAlert, animated: true, completion: nil)
    }
    @objc // 회원정보 수정 버튼 클릭
    private func editBtnTapped() {
        // UserDefaults에서 userId 가져오기
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            print("사용자 ID를 찾을 수 없음")
            return
        }

        // 저장된 userId출력
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            print("저장된 userId: \(savedUserId)")
        }
        
        // 화면 이동
        let edit = EditInfoVC(userId: userId)
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
    @objc //회원탈퇴 버튼 클릭
    private func deleteBtnTapped() {
        // 저장된 userId출력
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            print("저장된 userId: \(savedUserId)")
        }
        
        // 화면 이동
        let delete = DeleteInfoVC() //
        self.navigationController?.pushViewController(delete, animated: true)
    }
}

// MARK: - Extensions
extension MyPageCustomView {
    func updateDetailText(_ text: String) {
        self.detailLabel.text = text
    }
}
extension Notification.Name { // MyPageMainVC에서 수신할 Notification을 정의
    static let userInfoUpdated = Notification.Name("userInfoUpdated")
}
/*
 
 MARK: ToDo
 라이프 사이클 부분 데이터 새로고침 되는 부분 수정
 유저 데이터 가져오는 부분 수정
 
*/
