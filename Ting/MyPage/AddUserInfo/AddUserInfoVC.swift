//
//  AddUserInfoVC.swift
//  Ting
//
//  Created by 이재건 on 2/4/25.
//

import UIKit
import SnapKit
import Then

class AddUserInfoVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Components
    // 다양한 기종 대응하기 위해, 특히 소형기종 위해 스크롤뷰로 구현
    // 기본사이즈 이상, 플러스 맥스 사이즈에서는 스크롤 뷰 작동하지 않아도 정상 출력
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원정보 추가"
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
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 10
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true // Navigation Bar 가리기
        
        configureUI()
        
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
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }

        // ScrollView (CardView만 스크롤 가능하게 설정)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
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
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        // 카드 뷰 안에 textField들 추가
        cardView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }

        [nickNameField, roleField, techStackField, toolField, workStyleField, locationField, interestField].forEach {
            stackView.addArrangedSubview($0)
        }

        // Save Button (고정)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20) // view.safeAreaLayoutGuide와 맞추기
            $0.height.equalTo(50)
        }
    }
    
    
    // MARK: - Save Button Action & Firebase에 업로드
    @objc
    private func saveBtnTapped() {
        // MARK: 닉네임 중복 검사
        let nickname = nickNameField.textField.text ?? ""
        
        UserInfoService.shared.checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            
            if isDuplicate {
                DispatchQueue.main.async {
                    self.basicAlert(title: "오류", message: "중복된 닉네임입니다.\n다른 닉네임을 입력해 주세요.")
                }
                return
            }
            
            // MARK: - Firebase Create
            // userInfo 객체 생성
            let userInfo = UserInfo(
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
            let isAddInfoEmpty = [
                userInfo.nickName,
                userInfo.role,
                userInfo.techStack,
                userInfo.tool,
                userInfo.workStyle,
                userInfo.location,
                userInfo.interest
            ]
            
            // 텍스트 필드가 전부 채워졌는지 확인하고 서버에 업로드
            if isAddInfoEmpty.allSatisfy({ !$0.isEmpty }) {
                UserInfoService.shared.createUserInfo(info: userInfo) { result in
                    switch result {
                    case .success:
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.window?.rootViewController = TabBar() // 메인화면으로 이동
                        print("업로드 성공. | UserDefaults 저장 성공 | MainView로 이동함")
                    case .failure(let error):
                        print("업로드 실패: \(error)")
                    }
                }
            } else {
                basicAlert(title: "오류", message: "빈칸 없이 입력해주세요.")
            }
        }
    }
    
    // MARK: 키보드 설정
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


/*

MARK: - Todo

 글자수 제한
 한글 영어 구분
 키보드가 텍스트 필드 가리는 부분 수정
 공백
 
*/
