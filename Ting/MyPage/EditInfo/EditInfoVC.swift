//
//  DeleteInfoVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then

class EditInfoVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Components
    // 다양한 기종 대응하기 위해, 특히 소형기종 위해 스크롤뷰로 구현
    // 기본사이즈 이상, 플러스 맥스 사이즈에서는 스크롤 뷰 작동하지 않아도 정상 출력
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userId: String
    private var originalNickName: String? // 서버에 있는 닉네임
        
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원정보 수정"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 30)
        $0.textAlignment = .left
    }
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // textField 항목들
    private let nickNameField = EditCustomView(labelText: "닉네임", placeholder: "  닉네임을 입력하세요")
    private let roleField = EditCustomView(labelText: "직군", placeholder: "  예: 개발자, 디자이너, 기획자")
    private let techStackField = EditCustomView(labelText: "기술 스택", placeholder: "  예: Swift, Kotlin")
    private let toolField = EditCustomView(labelText: "사용 툴", placeholder: "  예: Xcode, Android Studio")
    private let workStyleField = EditCustomView(labelText: "협업 방식", placeholder: "  예: 온라인, 오프라인, 무관")
    private let locationField = EditCustomView(labelText: "지역", placeholder: "  거주 지역을 입력하세요")
    private let interestField = EditCustomView(labelText: "관심사", placeholder: "  관심 있는 분야를 입력하세요")
    
    // 저장하기 버튼
    private lazy var saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .primaries
        $0.layer.cornerRadius = 10
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .primaries // 네비게이션 바 Back버튼 컬러 변경
        
        configureUI()
        fetchUserData()
        
        // 키보드 설정 위해 delegate 적용
        [nickNameField, roleField, techStackField, toolField, workStyleField, locationField, interestField].forEach {
            $0.textField.delegate = self
        }
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .background
        
        // Title Label (고정)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(30)
        }
        
        // ScrollView (CardView만 스크롤 가능하게 설정)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80) // 저장 버튼 공간 확보
        }
        
        // ContentView 추가 (ScrollView 내부에 포함)
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // 가로 스크롤 방지
        }
        
        // CardView 추가 (ScrollView 내부에 포함)
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(16)
        }
                
        cardView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        [nickNameField, roleField, techStackField, toolField, workStyleField, locationField, interestField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20) // view.safeAreaLayoutGuide와 맞추기
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Firebase Data Fetching (Read)
    // 서버에서 데이터 받아와서 텍스트 필드에 기존 데이터 출력
    private func fetchUserData() {
        UserInfoService.shared.fetchUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    self.showPreviousInfo(with: userInfo)
                    self.originalNickName = userInfo.nickName
                }
            case .failure(let error):
                print("데이터 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // textField에 기존 정보들 출력
    private func showPreviousInfo(with userInfo: UserInfo) {
        nickNameField.updateDetailText(userInfo.nickName)
        roleField.updateDetailText(userInfo.role)
        techStackField.updateDetailText(userInfo.techStack)
        toolField.updateDetailText(userInfo.tool)
        workStyleField.updateDetailText(userInfo.workStyle)
        locationField.updateDetailText(userInfo.location)
        interestField.updateDetailText(userInfo.interest)
    }
    
    // MARK: - Save Button Action
    @objc
    private func saveBtnTapped() {
        let nickname = nickNameField.textField.text ?? "" // 현재 텍스트필드에 있는 닉네임
        
        // MARK: 닉네임 중복 검증
        // 닉네임이 변경되지 않은 경우 바로 저장
        if nickname == originalNickName { // 서버에 있는 닉네임과 대조
            saveUserInfo()
            print("닉네임 변경 없음. 중복검사 생략")
        } else {
            // 닉네임이 변경된 경우 중복 검사 후 저장
            UserInfoService.shared.checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if isDuplicate {
                        self.basicAlert(title: "오류", message: "중복된 닉네임입니다.\n 다른 닉네임을 입력해 주세요.")
                    } else {
                        // 중복되지 않은 경우 저장 진행
                        self.saveUserInfo()
                    }
                }
            }
        }
    }
    
    // MARK: - 변경된 회원정보 서버에 업로드 Firebase Update
    private func saveUserInfo() {
        // userInfo 객체 생성
        let updatedUserInfo = UserInfo(
            userId: userId,
            nickName: nickNameField.textField.text ?? "",
            role: roleField.textField.text ?? "",
            techStack: techStackField.textField.text ?? "",
            tool: toolField.textField.text ?? "",
            workStyle: workStyleField.textField.text ?? "",
            location: locationField.textField.text ?? "",
            interest: interestField.textField.text ?? ""
        )
        
        // textField가 다 채워졌는지 확인하기 위해 배열에 저장
        let isUpdateInfoEmpty = [
            updatedUserInfo.nickName,
            updatedUserInfo.role,
            updatedUserInfo.techStack,
            updatedUserInfo.tool,
            updatedUserInfo.workStyle,
            updatedUserInfo.location,
            updatedUserInfo.interest
        ]
        
        // MARK: 회원정보 업데이트 Firebase Update
        if isUpdateInfoEmpty.allSatisfy({ !$0.isEmpty }) {
            UserInfoService.shared.updateUserInfo(userInfo: updatedUserInfo) { [weak self] result in
                switch result {
                case .success:
                    // 저장 성공 후 Notification 보내기
                    NotificationCenter.default.post(name: .userInfoUpdated, object: nil)
                    
                    // 마이페이지로 돌아가기
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    print("회원정보 수정 성공. | MainView로 이동함")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.basicAlert(title: "오류", message: "회원정보 수정에 실패했습니다. \(error.localizedDescription)")
                    }
                }
            }
        } else {
            basicAlert(title: "오류", message: "빈칸 없이 입력해주세요.")
        }
    }
    
    //MARK: 키보드 설정
    //다른 공간 터치시 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Return 키를 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 내림
        return true
    }
    
    // MARK: - 글자 수 제한 20자 이하
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 20
    }
}

extension EditCustomView {
    func updateDetailText(_ text: String) {
        self.textField.text = text
    }
}

// MARK: - TODO
/*
 
 - 플레이스 홀더 말고 텍스트로 출력
 
 - 수정 취소 버튼?
 - 수정완료 얼럿 띄우고 확인시 이동
 - 클리어버튼 색상 변경 (커스텀에서 확인)
 
*/
