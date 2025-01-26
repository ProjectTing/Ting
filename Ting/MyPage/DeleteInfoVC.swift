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
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let label = UILabel().then {
        $0.text = "회원 탈퇴 안내"
        $0.textColor = .brownText
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 15)
    }
    private let label2 = UILabel().then {
        $0.text = "블머낭러미;나어리"
        $0.textColor = .deepCocoa
        $0.textAlignment = .left
    }
    private let button = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
//    // 네비게이션 바 가리기
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false) // 네비게이션 바 숨기기
//    }
//    // 다른 뷰로 이동할 때 다시 보이기
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false) // 원래대로 복구
//    }
    
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
        
        // 내부 요소 추가
        cardView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        
        cardView.addSubview(label2)
        label2.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(10) // 간격 조정
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
        
        // cardView 크기 자동 조정
        cardView.snp.makeConstraints {
            $0.bottom.equalTo(label2.snp.bottom).offset(20) // 크기 최소화
        }
        
        // 버튼 추가 및 위치 조정
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200) // 버튼 너비 설정
            $0.height.equalTo(40) // 버튼 높이 설정
        }
    }
}


// MARK: - TODO
/*
 
 - 라디오 버튼
 - 버튼 액션
 - 네비게이션바 논의
 
*/
