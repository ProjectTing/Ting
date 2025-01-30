//
//  LabelAndTextFieldView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

/// 커스텀뷰 (타이틀 + 텍스트필드)
final class LabelAndTextFieldView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    let textField = UITextField().then {
        $0.font = .systemFont(ofSize: 18)
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayCloud.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        setupUI(labelTitle: title, placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI(labelTitle: String, placeholder: String) {
        titleLabel.text = labelTitle
        textField.placeholder = placeholder
        
        addSubviews(titleLabel, textField)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}
