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
    
    private let nameField = EditCustomView(labelText: "이름", placeholder: "  이름을 입력하세요")
    private let techStackField = EditCustomView(labelText: "기술 스택", placeholder: "  예: Swift, Kotlin")
    private let toolField = EditCustomView(labelText: "사용 툴", placeholder: "  예: Xcode, Android Studio")
    private let workStyleField = EditCustomView(labelText: "협업 방식", placeholder: "  예: 온라인, 오프라인, 무관")
    private let locationField = EditCustomView(labelText: "지역", placeholder: "  거주 지역을 입력하세요")
    private let interestField = EditCustomView(labelText: "관심사", placeholder: "  관심 있는 분야를 입력하세요")
    
    
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
        self.navigationController?.navigationBar.tintColor = .primary // 네비게이션 바 Back버튼 컬러 변경
        
        configureUI()
        
        // 키보드 설정 위해 delegate 적용
        [nameField, techStackField, toolField, workStyleField, locationField, interestField].forEach {
            $0.textField.delegate = self
        }
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(30)
        }
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        cardView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        [nameField, techStackField, toolField, workStyleField, locationField, interestField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Button Actions
    @objc
    private func saveBtnTapped() {
        let nickname = nameField.textField.text ?? ""
        
        UserInfoService.shared.checkNicknameDuplicate(nickname: nickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            
            if isDuplicate {
                DispatchQueue.main.async {
                    self.basicAlert(title: "오류", message: "중복된 닉네임입니다. 다른 닉네임을 입력해 주세요.")
                }
                return
            }
            
            // 정보 업데이트 로직 수행
            self.navigationController?.popViewController(animated: true)
            // TODO: Firestore 업데이트 로직 추가 필요
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
}


// MARK: - TODO
/*
 
 - 수정 취소 버튼?
 - 수정완료 얼럿 띄우고 확인시 이동
 - 클리어버튼 색상 변경 (커스텀에서 확인)
 
*/
