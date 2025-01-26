//
//  DeleteInfoVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then

class EditInfoVC: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "회원정보 수정"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    private let nameField = EditCustomView(labelText: "이름", placeholder: "이름을 입력하세요")
    private let skillStackField = EditCustomView(labelText: "기술 스택", placeholder: "예: Swift, Kotlin")
    private let toolField = EditCustomView(labelText: "사용 툴", placeholder: "예: Xcode, Android Studio")
    private let workStyleField = EditCustomView(labelText: "협업 방식", placeholder: "예: 온라인, 오프라인, 무관")
    private let locationField = EditCustomView(labelText: "지역", placeholder: "거주 지역을 입력하세요")
    private let interestField = EditCustomView(labelText: "관심사", placeholder: "관심 있는 분야를 입력하세요")
    
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.backgroundColor = .brownText
        $0.layer.cornerRadius = 8
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
//    // 네비게이션 바 가리기
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    // 다른 뷰로 이동할 때 다시 보이기
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        cardView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        [nameField, skillStackField, toolField, workStyleField, locationField, interestField].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}


// MARK: - TODO
/*
 
 - 수정 취소 버튼?
 - 키보드 설정
 - 버튼 액션
 
*/
