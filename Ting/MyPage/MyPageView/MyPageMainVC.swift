//
//  MyPageMainVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then

class MyPageMainVC: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textAlignment = .left
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 30)
    }
    
    // cardView 1에 들어갈 내용들
    private let cardView1 = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let nickName = UILabel().then {
        $0.text = "홍길동"
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
    }
    private let role = UILabel().then {
        $0.text = "개발자"
        $0.textColor = .deepCocoa
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    private lazy var stackView1 = UIStackView(arrangedSubviews: [nickName, role]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // cardView 2에 들어갈 내용들
    private let cardView2 = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    private let nameField = MyPageCustomView(title: "이름", detail: "이름을 입력하세요")
    private let skillStackField = MyPageCustomView(title: "기술 스택", detail: "예: Swift, Kotlin")
    private let toolField = MyPageCustomView(title: "사용 툴", detail: "예: Xcode, Android Studio")
    private let workStyleField = MyPageCustomView(title: "협업 방식", detail: "예: 온라인, 오프라인, 무관")
    private let locationField = MyPageCustomView(title: "지역", detail: "거주 지역을 입력하세요")
    private let interestField = MyPageCustomView(title: "관심사", detail: "관심 있는 분야를 입력하세요")
    
    private lazy var editBtn = UIButton(type: .system).then {
        $0.setTitle("회원정보 수정", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
    }
    private lazy var deleteBtn = UIButton(type: .system).then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .accent
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }
    private lazy var stackView2 = UIStackView(arrangedSubviews: [
        nameField,
        skillStackField,
        toolField,
        workStyleField,
        locationField,
        interestField
    ]).then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    private lazy var btnStackView = UIStackView(arrangedSubviews: [editBtn, deleteBtn]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
    }
    // 네비게이션 바 가리기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false) // 네비게이션 바 숨기기
    }
    // 다른 뷰로 이동할 때 다시 보이기
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false) // 원래대로 복구
    }
    
    // MARK: - configure UI
    private func configureUI() {
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(cardView1)
        cardView1.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        cardView1.addSubview(stackView1)
        stackView1.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        view.addSubview(cardView2)
        cardView2.snp.makeConstraints {
            $0.top.equalTo(cardView1.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        cardView2.addSubview(stackView2)
        stackView2.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        view.addSubview(btnStackView)
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(cardView2.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        editBtn.snp.makeConstraints {
            $0.height.equalTo(40) // 50으로 하면 짤림
        }
        deleteBtn.snp.makeConstraints {
            $0.height.equalTo(40) // 50으로 하면 짤림
        }
     }
    
    // MARK: - Button Actions
    @objc
    private func editBtnTapped() {
        let edit = EditInfoVC()
        self.navigationController?.pushViewController(edit, animated: true)
    }
    @objc
    private func deleteBtnTapped() {
        let delete = DeleteInfoVC()
        self.navigationController?.pushViewController(delete, animated: true)
    }
}

