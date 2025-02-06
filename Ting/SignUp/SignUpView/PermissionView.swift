//
//  PermissionView.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//
    
import UIKit
import SnapKit
import Then

/// 첫 번째 화면 (PermissionView)
class PermissionView: UIView {
    
    var onNextButtonTap: (() -> Void)?

    // 제목 레이블
    let titleLabel = UILabel().then {
        $0.text = "프로젝트를 위한 완벽한 매칭"
        $0.textColor = .accent
        $0.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        $0.textAlignment = .left
    }

    // 서비스 이름 (Ting) 레이블
    let nameLabel = UILabel().then {
        $0.text = "Ting"
        $0.textColor = .primary
        $0.font = UIFont(name: "Gemini Moon", size: 55) // Gemini Moon 폰트 적용
        $0.textAlignment = .left
    }

    // "다음" 버튼
    let nextButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 10
    }

    // 약관 동의 안내 문구 (Tap Gesture를 이용해 텍스트 일부 클릭 가능)
    let agreementLabel = UILabel().then {
        let fullText = "가입 버튼을 클릭으로, Ting 이용 약관에 동의합니다."
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "이용 약관")
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        $0.attributedText = attributedString
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
    }

    weak var parentViewController: UIViewController?  // 부모 뷰 컨트롤러 참조

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()  // Tap Gesture 추가
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI 설정
    private func setupUI() {
        backgroundColor = .background

        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(nextButton)
        addSubview(agreementLabel)

        // 제목 레이블 위치 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(60)
            $0.leading.equalToSuperview().offset(20)
        }

        // 서비스 이름 (Ting) 위치 설정
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        // "다음" 버튼 위치 설정
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-80)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }

        // 약관 동의 문구 위치 설정
        agreementLabel.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - Gesture 설정
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsTapped))
        agreementLabel.addGestureRecognizer(tapGesture)
    }

    // MARK: - 약관 클릭 시 호출되는 메서드
    @objc private func termsTapped() {
        print("이용 약관 텍스트 클릭됨")
    }
    
    @objc private func nextButtonTapped() {
        onNextButtonTap?()
    }
    
}



