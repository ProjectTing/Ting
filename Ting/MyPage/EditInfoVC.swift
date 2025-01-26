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
        $0.font = .boldSystemFont(ofSize: 30)
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
    
    private let nameField = EditCustomView(labelText: "이름", placeholder: "  이름을 입력하세요")
    private let skillStackField = EditCustomView(labelText: "기술 스택", placeholder: "  예: Swift, Kotlin")
    private let toolField = EditCustomView(labelText: "사용 툴", placeholder: "  예: Xcode, Android Studio")
    private let workStyleField = EditCustomView(labelText: "협업 방식", placeholder: "  예: 온라인, 오프라인, 무관")
    private let locationField = EditCustomView(labelText: "지역", placeholder: "  거주 지역을 입력하세요")
    private let interestField = EditCustomView(labelText: "관심사", placeholder: "  관심 있는 분야를 입력하세요")
    
    
    private let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        $0.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
    
    // MARK: - Button Actions
    @objc
    private func saveBtnTapped() {
        self.navigationController?.popViewController(animated: true) // pop으로 현재뷰 삭제되고 이전뷰로 이동
    }
}


// MARK: - TODO
/*
 
 - 수정 취소 버튼?
 - 수정완료 얼럿 띄우고 확인시 이동
 
*/
