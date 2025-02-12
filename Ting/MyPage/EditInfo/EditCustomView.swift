//
//  EditInfoCustomVIew.swift
//  Ting
//
//  Created by 이재건 on 1/26/25.
//

import UIKit
import SnapKit
import Then

class EditCustomView: UIView {
    
    // MARK: - UI Components
    private let label = UILabel().then {
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    public let textField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .brownText
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 1.0 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primaries.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        
        // MARK: 키보드 설정
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    }
    
    // MARK: - 초기화
    init(labelText: String, placeholder: String) {
        super.init(frame: .zero)
        label.text = labelText
        //textField.placeholder = placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.grayCloud // Placeholder 색상 변경
            ]
        )
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setUpUI
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [label, textField]).then {
            $0.axis = .vertical
            $0.spacing = 3
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        label.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - 크기 지정
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30) // stackView간의 기본 높이 설정
    }
}


