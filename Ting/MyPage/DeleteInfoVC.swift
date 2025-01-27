//
//  EditInfoVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import Then

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
    private let policyTitle = UILabel().then {
        $0.text = "회원 탈퇴 안내"
        $0.textColor = .brownText
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let policyDetail = UILabel().then {
        $0.text = "회원 탈퇴 안내 약관이 들어올 자리"
        $0.textColor = .deepCocoa
        $0.textAlignment = .left
    }
    private let checkIcon = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle.fill")
        $0.tintColor = .grayCloud // 기본 비활성화 색상
        $0.isUserInteractionEnabled = true // 사용자 터치 가능하도록 설정
    }
    private let agreement = UILabel().then {
        $0.text = "약관을 확인했으며, 회원 탈퇴에 동의합니다"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .deepCocoa
        $0.textAlignment = .left
    }
    // 현재 체크 상태 저장
    private var isChecked = false {
        didSet {
            checkIcon.tintColor = isChecked ? .accent : .grayCloud
        }
    }
    private lazy var stackView = UIStackView(arrangedSubviews: [checkIcon, agreement]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillProportionally
    }
    private let deleteBtn = UIButton().then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cardView.addSubview(policyDetail)
        policyDetail.snp.makeConstraints {
            $0.top.equalTo(policyTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        // cardView 크기 자동 조정
        cardView.snp.makeConstraints {
            $0.bottom.equalTo(policyDetail.snp.bottom).offset(20)
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
            $0.width.equalTo(200) // 버튼 너비 설정
            $0.height.equalTo(50) // 버튼 높이 설정
        }
    }
    
    // 체크 아이콘에 클릭 이벤트 추가
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        checkIcon.addGestureRecognizer(tapGesture)
    }
    
    // 체크 상태 변경 (토글)
    @objc
    private func toggleCheck() {
        isChecked.toggle()
    }
    
    // MARK: - Button Actions
    @objc
    private func deleteBtnTapped() {
        let firstPage = SignUpViewController()
        self.navigationController?.pushViewController(firstPage, animated: true)
    }
}


// MARK: - TODO
/*
 
- 체크아이콘 클릭시에만 탈퇴 버튼 활성화
 
*/
