//
//  LabelAndTextField.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

/// 커스텀뷰 (타이틀 + 텍스트필드)
final class LabelAndTextField: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    let textField = UITextField().then {
        $0.font = .systemFont(ofSize: 18)
        $0.borderStyle = .none
        $0.backgroundColor = .white
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayCloud.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    var postType: PostType?
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        setupUI(labelTitle: title, placeholder: placeholder)
        textField.delegate = self
        textField.becomeFirstResponder()
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

extension LabelAndTextField: UITextFieldDelegate {
    
    // 텍스트필드의 입력이 시작되면 호출 (시점)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // 텍스트필드의 엔터키가 눌러졌을때 호출 (동작할지 말지 물어보는 것)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 글자 수 제한 20자 이하
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 20
    }
}
